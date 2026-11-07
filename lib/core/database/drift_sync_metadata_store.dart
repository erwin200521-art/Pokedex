import 'package:drift/drift.dart';

import '../sync/sync_metadata.dart';
import 'app_database.dart';

/// Implementación Drift de [SyncMetadataStore] sobre la tabla `sync_metadata_entries`.
class DriftSyncMetadataStore implements SyncMetadataStore {
  DriftSyncMetadataStore(this._db);

  final AppDatabase _db;

  @override
  Future<SyncMetadata?> read(String resourceKey) async {
    final row = await _query(resourceKey).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Stream<SyncMetadata?> watch(String resourceKey) {
    return _query(resourceKey)
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toModel(row));
  }

  @override
  Stream<DateTime?> watchLastSuccess() {
    return _db.select(_db.syncMetadataEntries).watch().map((rows) {
      DateTime? latest;
      for (final row in rows) {
        final at = row.lastSuccessAt;
        if (at != null && (latest == null || at.isAfter(latest))) latest = at;
      }
      return latest;
    });
  }

  @override
  Future<void> markInProgress(String resourceKey, {required int cursor}) {
    return _upsert(
      SyncMetadataEntriesCompanion(
        resourceKey: Value(resourceKey),
        status: Value(SyncStatus.inProgress.name),
        cursor: Value(cursor),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markCompleted(String resourceKey, DateTime at) {
    return _upsert(
      SyncMetadataEntriesCompanion(
        resourceKey: Value(resourceKey),
        status: Value(SyncStatus.completed.name),
        cursor: const Value(0),
        lastSuccessAt: Value(at),
        lastError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> markFailed(String resourceKey, String error) {
    return _upsert(
      SyncMetadataEntriesCompanion(
        resourceKey: Value(resourceKey),
        status: Value(SyncStatus.failed.name),
        lastError: Value(error),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  SimpleSelectStatement<$SyncMetadataEntriesTable, SyncMetadataRow> _query(
    String resourceKey,
  ) {
    return _db.select(_db.syncMetadataEntries)
      ..where((t) => t.resourceKey.equals(resourceKey));
  }

  Future<void> _upsert(SyncMetadataEntriesCompanion entry) {
    return _db.into(_db.syncMetadataEntries).insertOnConflictUpdate(entry);
  }

  SyncMetadata _toModel(SyncMetadataRow row) {
    return SyncMetadata(
      resourceKey: row.resourceKey,
      status: SyncStatus.values.asNameMap()[row.status] ?? SyncStatus.idle,
      cursor: row.cursor,
      lastSuccessAt: row.lastSuccessAt,
      lastError: row.lastError,
    );
  }
}
