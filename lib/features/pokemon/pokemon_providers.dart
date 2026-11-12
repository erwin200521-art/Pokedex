import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/sync/sync_task.dart';
import 'data/datasources/pokemon_local_data_source.dart';
import 'data/datasources/pokemon_remote_data_source.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'data/sync/catalog_sync_task.dart';
import 'domain/repositories/pokemon_repository.dart';
import 'domain/usecases/refresh_catalog.dart';
import 'domain/usecases/watch_catalog.dart';

/// Composición (inyección de dependencias) de la funcionalidad Pokémon.
/// Las páginas solo consumen los casos de uso; nunca el cliente GraphQL ni la
/// base de datos (restricción de la capa Presentation, §8.1).

final pokemonRemoteDataSourceProvider = Provider<PokemonRemoteDataSource>((ref) {
  return GraphQlPokemonRemoteDataSource(ref.watch(graphQlClientProvider));
});

final pokemonLocalDataSourceProvider = Provider<PokemonLocalDataSource>((ref) {
  return PokemonLocalDataSource(
    ref.watch(appDatabaseProvider),
    ref.watch(syncMetadataStoreProvider),
  );
});

/// Tarea que se registra en el coordinador (ver `app/bootstrap.dart`).
final catalogSyncTaskProvider = Provider<SyncTask>((ref) {
  return CatalogSyncTask(
    remote: ref.watch(pokemonRemoteDataSourceProvider),
    local: ref.watch(pokemonLocalDataSourceProvider),
    metadataStore: ref.watch(syncMetadataStoreProvider),
  );
});

final pokemonRepositoryProvider = Provider<PokemonRepository>((ref) {
  return PokemonRepositoryImpl(
    local: ref.watch(pokemonLocalDataSourceProvider),
    coordinator: ref.watch(syncCoordinatorProvider),
  );
});

final watchCatalogProvider = Provider<WatchCatalog>(
  (ref) => WatchCatalog(ref.watch(pokemonRepositoryProvider)),
);

final refreshCatalogProvider = Provider<RefreshCatalog>(
  (ref) => RefreshCatalog(ref.watch(pokemonRepositoryProvider)),
);
