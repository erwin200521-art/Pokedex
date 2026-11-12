import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/network/connectivity_monitor.dart';
import '../../../../core/sync/sync_state.dart';
import '../../domain/entities/pokemon.dart';

/// Estados explícitos de la pantalla del catálogo (RF-CAT-04, OE-06):
/// carga, éxito, ausencia de datos y error.
sealed class CatalogUiState {
  const CatalogUiState();
}

final class CatalogLoading extends CatalogUiState {
  const CatalogLoading({this.downloading = false});

  /// `true` cuando se está descargando el catálogo por primera vez.
  final bool downloading;
}

final class CatalogLoaded extends CatalogUiState {
  const CatalogLoaded(this.pokemon);

  final List<Pokemon> pokemon;
}

enum CatalogEmptyReason {
  /// Instalación nueva y sin conexión: estado vacío útil (PA-15).
  offlineNoData,
  noData,
}

final class CatalogEmpty extends CatalogUiState {
  const CatalogEmpty(this.reason);

  final CatalogEmptyReason reason;
}

final class CatalogError extends CatalogUiState {
  const CatalogError(this.failure);

  final Failure failure;
}

/// Combina la base local (fuente de la UI) con el estado de conectividad y de
/// sincronización. Función pura: se prueba sin Flutter.
///
/// * Con datos locales SIEMPRE se muestran, sea cual sea el estado de la red
///   (OF-05, OF-04): los fallos remotos no ocultan datos válidos.
/// * Sin datos locales, el estado explica por qué (descargando, offline, error).
CatalogUiState resolveCatalogState({
  required AsyncValue<List<Pokemon>> catalog,
  required SyncState sync,
  required ServiceAvailability availability,
}) {
  return catalog.when(
    loading: () => const CatalogLoading(),
    error: (error, _) => CatalogError(mapToFailure(error)),
    data: (pokemon) {
      if (pokemon.isNotEmpty) return CatalogLoaded(pokemon);

      if (sync.isSyncing || availability == ServiceAvailability.verifying) {
        return const CatalogLoading(downloading: true);
      }
      if (availability == ServiceAvailability.offline) {
        return const CatalogEmpty(CatalogEmptyReason.offlineNoData);
      }
      if (availability == ServiceAvailability.serviceUnavailable) {
        return const CatalogError(ServiceUnavailableFailure());
      }
      final failure = sync.lastFailure;
      if (failure != null) return CatalogError(failure);
      if (sync.syncedThisSession) {
        return const CatalogEmpty(CatalogEmptyReason.noData);
      }
      // En línea, aún sin iniciar la sincronización: se muestra la carga.
      return const CatalogLoading(downloading: true);
    },
  );
}
