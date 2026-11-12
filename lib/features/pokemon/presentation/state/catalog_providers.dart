import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers.dart';
import '../../domain/entities/pokemon.dart';
import '../../pokemon_providers.dart';
import 'catalog_ui_state.dart';

/// Flujo del catálogo observado desde la base local. La UI jamás consume
/// respuestas GraphQL (OF-17).
final catalogStreamProvider = StreamProvider.autoDispose<List<Pokemon>>((ref) {
  return ref.watch(watchCatalogProvider)();
});

/// Estado de pantalla derivado (carga / éxito / vacío / error).
final catalogUiStateProvider = Provider.autoDispose<CatalogUiState>((ref) {
  return resolveCatalogState(
    catalog: ref.watch(catalogStreamProvider),
    sync: ref.watch(syncStateProvider),
    availability: ref.watch(availabilityProvider),
  );
});
