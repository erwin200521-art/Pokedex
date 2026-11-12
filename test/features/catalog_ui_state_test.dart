import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/error/failure.dart';
import 'package:pokedex/core/network/connectivity_monitor.dart';
import 'package:pokedex/core/sync/sync_state.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex/features/pokemon/presentation/state/catalog_ui_state.dart';

const _bulbasaur = Pokemon(
  id: 1,
  name: 'bulbasaur',
  nationalDexNumber: 1,
  types: ['grass', 'poison'],
  spriteUrl: 'sprite',
  artworkUrl: 'art',
);

void main() {
  group('resolveCatalogState', () {
    test('con datos locales se muestran aunque esté offline (OF-05)', () {
      final state = resolveCatalogState(
        catalog: const AsyncValue.data([_bulbasaur]),
        sync: const SyncState(),
        availability: ServiceAvailability.offline,
      );
      expect(state, isA<CatalogLoaded>());
    });

    test('con datos locales se muestran aunque la API falle (OF-04)', () {
      final state = resolveCatalogState(
        catalog: const AsyncValue.data([_bulbasaur]),
        sync: const SyncState(
          phase: SyncPhase.waitingRetry,
          lastFailure: ServiceUnavailableFailure(),
        ),
        availability: ServiceAvailability.serviceUnavailable,
      );
      expect(state, isA<CatalogLoaded>());
    });

    test('sin datos y offline: estado vacío útil (PA-15)', () {
      final state = resolveCatalogState(
        catalog: const AsyncValue.data(<Pokemon>[]),
        sync: const SyncState(),
        availability: ServiceAvailability.offline,
      );
      expect(state, isA<CatalogEmpty>());
      expect((state as CatalogEmpty).reason, CatalogEmptyReason.offlineNoData);
    });

    test('sin datos y sincronizando: carga con descarga inicial (PA-01)', () {
      final state = resolveCatalogState(
        catalog: const AsyncValue.data(<Pokemon>[]),
        sync: const SyncState(phase: SyncPhase.syncing),
        availability: ServiceAvailability.online,
      );
      expect(state, isA<CatalogLoading>());
      expect((state as CatalogLoading).downloading, isTrue);
    });

    test('sin datos y API no disponible: error con reintento', () {
      final state = resolveCatalogState(
        catalog: const AsyncValue.data(<Pokemon>[]),
        sync: const SyncState(),
        availability: ServiceAvailability.serviceUnavailable,
      );
      expect(state, isA<CatalogError>());
    });

    test('error del flujo local se traduce a un fallo del dominio', () {
      final state = resolveCatalogState(
        catalog: AsyncValue.error(Exception('boom'), StackTrace.empty),
        sync: const SyncState(),
        availability: ServiceAvailability.online,
      );
      expect(state, isA<CatalogError>());
    });
  });
}
