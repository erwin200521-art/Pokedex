import 'package:drift/drift.dart';

// Modelo de datos local (PS-01, ver docs/data-model.md y Diagrama 6).
//
// Catálogo (autoridad remota, se restaura desde PokeAPI): Pokemons,
// ElementTypes, PokemonTypeLinks.
// Datos del usuario (solo locales, nunca los toca la sincronización del
// catálogo, PS-11): Favorites.
// Metadatos de sincronización: SyncMetadataEntries.

/// Pokémon del catálogo. Clave primaria = id de PokeAPI (PS-05), estable entre
/// sincronizaciones, lo que permite el upsert sin duplicados (PS-06).
@DataClassName('PokemonRow')
@TableIndex(name: 'idx_pokemons_name', columns: {#name})
@TableIndex(name: 'idx_pokemons_dex', columns: {#nationalDexNumber})
class Pokemons extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();

  /// Número de Pokédex nacional (= id de especie = id del Pokémon por defecto).
  IntColumn get nationalDexNumber => integer()();

  /// Altura en decímetros y peso en hectogramos (unidades de PokeAPI).
  IntColumn get height => integer()();
  IntColumn get weight => integer()();

  TextColumn get spriteUrl => text()();
  TextColumn get artworkUrl => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tipos elementales (fire, water...).
@DataClassName('ElementTypeRow')
class ElementTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Relación Pokémon ↔ tipo con su ranura (1 o 2).
@DataClassName('PokemonTypeLinkRow')
@TableIndex(name: 'idx_pokemon_type_links_type', columns: {#typeId})
class PokemonTypeLinks extends Table {
  IntColumn get pokemonId =>
      integer().references(Pokemons, #id, onDelete: KeyAction.cascade)();
  IntColumn get typeId => integer().references(ElementTypes, #id)();
  IntColumn get slot => integer()();

  @override
  Set<Column> get primaryKey => {pokemonId, slot};
}

/// Favoritos del usuario. Sin clave foránea al catálogo a propósito: ninguna
/// operación sobre el catálogo puede borrar o alterar favoritos (OF-21, PS-11).
@DataClassName('FavoriteRow')
class Favorites extends Table {
  IntColumn get pokemonId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {pokemonId};
}

/// Estado de sincronización por recurso (PS-09, PS-07). `cursor` es el offset
/// de la próxima página: permite reanudar tras una interrupción.
@DataClassName('SyncMetadataRow')
class SyncMetadataEntries extends Table {
  TextColumn get resourceKey => text()();
  TextColumn get status => text().withDefault(const Constant('idle'))();
  IntColumn get cursor => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSuccessAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {resourceKey};
}
