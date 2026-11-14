import 'dart:async';

import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/sync/sync_metadata.dart';
import '../dtos/pokemon_dto.dart';
import '../mappers/pokemon_mapper.dart';
import 'pokemon_record.dart';

/// Fuente de datos local del catálogo (Drift).
///
/// Es la ÚNICA fuente de lectura de la interfaz (OF-16): las respuestas
/// remotas solo llegan a la UI después de pasar por [savePage].
class PokemonLocalDataSource {
  PokemonLocalDataSource(this._db, this._metadata);

  final AppDatabase _db;
  final SyncMetadataStore _metadata;

  /// Catálogo observable, ordenado por número de Pokédex, con sus tipos.
  /// Usa los índices `idx_pokemons_dex` y `idx_pokemon_type_links_type`
  /// (RNF-REN-02).
  Stream<List<PokemonRecord>> watchCatalog() {
    final query = _db.select(_db.pokemons).join([
      leftOuterJoin(
        _db.pokemonTypeLinks,
        _db.pokemonTypeLinks.pokemonId.equalsExp(_db.pokemons.id),
      ),
      leftOuterJoin(
        _db.elementTypes,
        _db.elementTypes.id.equalsExp(_db.pokemonTypeLinks.typeId),
      ),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.pokemons.nationalDexNumber),
        OrderingTerm.asc(_db.pokemonTypeLinks.slot),
      ]);

    return query.watch().map(_group).transform(
          StreamTransformer<List<PokemonRecord>, List<PokemonRecord>>.fromHandlers(
            handleError: (error, stack, sink) => sink.addError(
              StorageException('No se pudo leer el catálogo local', error),
              stack,
            ),
          ),
        );
  }

  /// Cantidad de Pokémon almacenados (se usa en pruebas y para comunicar que
  /// el catálogo es parcial).
  Future<int> countPokemon() async {
    final count = _db.pokemons.id.count();
    final row = await (_db.selectOnly(_db.pokemons)..addColumns([count]))
        .getSingle();
    return row.read(count) ?? 0;
  }

  /// Guarda una página de forma ATÓMICA (RNF-RES-04, PS-06, PS-07):
  ///
  /// 1. upsert de Pokémon y tipos por clave primaria (sin duplicados);
  /// 2. reemplazo de las relaciones de los Pokémon de la página;
  /// 3. avance del cursor / cierre de la sincronización en la MISMA transacción.
  ///
  /// Si algo falla o la app se cierra, no queda nada a medias: o se confirma
  /// todo (datos + cursor) o nada.
  Future<void> savePage(
    List<PokemonDto> page, {
    required String resourceKey,
    required int nextCursor,
    required bool completed,
  }) async {
    try {
      await _db.transaction(() async {
        final now = DateTime.now();

        if (page.isNotEmpty) {
          final ids = [for (final dto in page) dto.id];
          final types = <int, ElementTypesCompanion>{};
          final links = <PokemonTypeLinksCompanion>[];
          for (final dto in page) {
            for (final type in dto.types) {
              types[type.typeId] =
                  ElementTypesCompanion.insert(id: Value(type.typeId), name: type.name);
              links.add(
                PokemonTypeLinksCompanion.insert(
                  pokemonId: dto.id,
                  typeId: type.typeId,
                  slot: type.slot,
                ),
              );
            }
          }

          await _db.batch((batch) {
            batch.insertAllOnConflictUpdate(
              _db.pokemons,
              [for (final dto in page) PokemonMapper.toCompanion(dto, now)],
            );
            batch.insertAllOnConflictUpdate(
              _db.elementTypes,
              types.values.toList(growable: false),
            );
            batch.deleteWhere(
              _db.pokemonTypeLinks,
              (t) => t.pokemonId.isIn(ids),
            );
            batch.insertAll(_db.pokemonTypeLinks, links);
          });
        }

        if (completed) {
          await _metadata.markCompleted(resourceKey, now);
        } else {
          await _metadata.markInProgress(resourceKey, cursor: nextCursor);
        }
      });
    } on Object catch (error) {
      throw StorageException('No se pudo guardar la página del catálogo', error);
    }
  }

  List<PokemonRecord> _group(List<TypedResult> rows) {
    final byId = <int, PokemonRecord>{};
    for (final result in rows) {
      final pokemon = result.readTable(_db.pokemons);
      final record =
          byId.putIfAbsent(pokemon.id, () => PokemonRecord(row: pokemon));
      final type = result.readTableOrNull(_db.elementTypes);
      if (type != null) record.typeNames.add(type.name);
    }
    return byId.values.toList(growable: false);
  }
}
