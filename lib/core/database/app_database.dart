import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// Base de datos SQLite (Drift). Es la fuente de verdad observable de la UI
/// (P-01, OF-16): las consultas `watch()` emiten cuando cambian las tablas.
///
/// `drift_flutter` abre la base en un isolate en segundo plano, por lo que las
/// consultas y escrituras no bloquean el hilo de interfaz (RNF-REN-03).
///
/// Código generado: `dart run build_runner build --delete-conflicting-outputs`.
@DriftDatabase(
  tables: [
    Pokemons,
    ElementTypes,
    PokemonTypeLinks,
    Favorites,
    SyncMetadataEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// [executor] permite inyectar una base en memoria en las pruebas.
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'pokedex'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        // Política de migraciones (PS-10): cada cambio de esquema incrementa
        // `schemaVersion` y añade aquí un paso `if (from < N)`. Las tablas del
        // catálogo son re-descargables; Favorites y trivia NUNCA se recrean.
        onUpgrade: (m, from, to) async {},
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
