/// Unidad de sincronización registrada por una funcionalidad (por ejemplo, el
/// catálogo de Pokémon). El [SyncCoordinator] las orquesta sin conocer su
/// contenido, de modo que `core/` no contiene lógica específica de cada feature.
abstract interface class SyncTask {
  /// Clave estable del recurso, usada en `sync_metadata_entries` (PS-09).
  String get resourceKey;

  /// `true` si el recurso está incompleto, falló antes o está desactualizado
  /// (PS-03).
  Future<bool> needsSync();

  /// Ejecuta la sincronización remoto → local. Debe ser idempotente y atómica
  /// por lote. Lanza excepciones de infraestructura si falla.
  Future<void> run();
}
