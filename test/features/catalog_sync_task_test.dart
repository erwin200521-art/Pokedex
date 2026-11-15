import 'dart:math';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/database/app_database.dart';
import 'package:pokedex/core/database/drift_sync_metadata_store.dart';
import 'package:pokedex/core/error/exceptions.dart';
import 'package:pokedex/core/sync/retry_policy.dart';
import 'package:pokedex/core/sync/sync_metadata.dart';
import 'package:pokedex/features/pokemon/data/datasources/pokemon_local_data_source.dart';
import 'package:pokedex/features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'package:pokedex/features/pokemon/data/dtos/pokemon_dto.dart';
import 'package:pokedex/features/pokemon/data/sync/catalog_sync_task.dart';

/// Remoto falso: genera [total] Pokémon y puede fallar en un offset concreto.
class FakeRemote implements PokemonRemoteDataSource {
  FakeRemote(this.total, {this.failAtOffset});

  final int total;
  final int? failAtOffset;
  final List<int> requestedOffsets = [];

  @override
  Future<List<PokemonDto>> fetchCatalogPage({
    required int offset,
    required int limit,
  }) async {
    requestedOffsets.add(offset);
    if (offset == failAtOffset) throw const NetworkException('sin red');
    final end = min(offset + limit, total);
    return [
      for (var id = offset + 1; id <= end; id++)
        PokemonDto(
          id: id,
          name: 'pokemon-$id',
          height: 10,
          weight: 100,
          types: [
            PokemonTypeDto(typeId: id % 3 + 1, name: 'type-${id % 3 + 1}', slot: 1),
          ],
        ),
    ];
  }
}

void main() {
  late AppDatabase db;
  late DriftSyncMetadataStore store;
  late PokemonLocalDataSource local;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    store = DriftSyncMetadataStore(db);
    local = PokemonLocalDataSource(db, store);
  });

  tearDown(() => db.close());

  CatalogSyncTask buildTask(FakeRemote remote, {DateTime Function()? clock}) {
    return CatalogSyncTask(
      remote: remote,
      local: local,
      metadataStore: store,
      pageSize: 100,
      retryPolicy: const RetryPolicy(maxAttempts: 1),
      clock: clock,
    );
  }

  Future<int> linkCount() async =>
      (await db.select(db.pokemonTypeLinks).get()).length;

  test('PA-13: sincronizar varias veces no genera duplicados', () async {
    final task = buildTask(FakeRemote(250));

    await task.run();
    final firstCount = await local.countPokemon();
    final firstLinks = await linkCount();

    await task.run();
    await task.run();

    expect(firstCount, 250);
    expect(await local.countPokemon(), 250);
    expect(await linkCount(), firstLinks);
    expect((await store.read(CatalogSyncTask.key))!.status, SyncStatus.completed);
  });

  test('PA-09/PS-07: tras una interrupción conserva lo guardado y reanuda', () async {
    final failing = buildTask(FakeRemote(250, failAtOffset: 100));
    await expectLater(failing.run(), throwsA(isA<NetworkException>()));

    // Solo la primera página quedó confirmada; no hay datos parciales.
    expect(await local.countPokemon(), 100);
    final afterFailure = (await store.read(CatalogSyncTask.key))!;
    expect(afterFailure.status, SyncStatus.failed);
    expect(afterFailure.cursor, 100);

    final resumingRemote = FakeRemote(250);
    await buildTask(resumingRemote).run();

    expect(resumingRemote.requestedOffsets.first, 100);
    expect(await local.countPokemon(), 250);
    expect((await store.read(CatalogSyncTask.key))!.status, SyncStatus.completed);
  });

  test('PS-03: un catálogo completo vuelve a sincronizarse al quedar desactualizado',
      () async {
    var now = DateTime.now();
    final task = buildTask(FakeRemote(10), clock: () => now);

    expect(await task.needsSync(), isTrue);
    await task.run();

    now = now.add(const Duration(minutes: 30));
    expect(await task.needsSync(), isFalse);

    now = now.add(const Duration(hours: 7));
    expect(await task.needsSync(), isTrue);
  });

  test('OF-19: un dato local alterado se restaura con la versión remota', () async {
    final task = buildTask(FakeRemote(10));
    await task.run();

    await (db.update(db.pokemons)..where((t) => t.id.equals(3)))
        .write(const PokemonsCompanion(name: Value('ALTERADO')));

    // Una nueva actualización (catálogo ya completo => arranca en offset 0)
    // sobrescribe con el dato remoto, que siempre prevalece.
    await task.run();

    final row = await (db.select(db.pokemons)..where((t) => t.id.equals(3))).getSingle();
    expect(row.name, 'pokemon-3');
  });
}
