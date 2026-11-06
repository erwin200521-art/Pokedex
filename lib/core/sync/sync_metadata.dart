/// Estado persistido de la sincronización de un recurso (PS-09).
enum SyncStatus { idle, inProgress, completed, failed }

class SyncMetadata {
  const SyncMetadata({
    required this.resourceKey,
    required this.status,
    required this.cursor,
    this.lastSuccessAt,
    this.lastError,
  });

  final String resourceKey;
  final SyncStatus status;

  /// Offset de la próxima página por descargar (reanudación, PS-07).
  final int cursor;
  final DateTime? lastSuccessAt;
  final String? lastError;
}

/// Contrato de los metadatos de sincronización. La implementación (Drift) vive
/// en `core/database`; el resto del código solo conoce esta abstracción.
abstract interface class SyncMetadataStore {
  Future<SyncMetadata?> read(String resourceKey);

  Stream<SyncMetadata?> watch(String resourceKey);

  /// Fecha de la última sincronización exitosa de cualquier recurso (IND-04).
  Stream<DateTime?> watchLastSuccess();

  /// Marca el recurso en curso y guarda el offset de la próxima página.
  /// Puede invocarse dentro de la misma transacción que escribe la página.
  Future<void> markInProgress(String resourceKey, {required int cursor});

  /// Marca la sincronización como completa y reinicia el cursor.
  Future<void> markCompleted(String resourceKey, DateTime at);

  /// Registra el fallo conservando el cursor, para reanudar.
  Future<void> markFailed(String resourceKey, String error);
}
