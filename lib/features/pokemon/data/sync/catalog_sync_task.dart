import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/sync/retry_policy.dart';
import '../../../../core/sync/sync_metadata.dart';
import '../../../../core/sync/sync_task.dart';
import '../../../../core/utils/app_log.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../datasources/pokemon_remote_data_source.dart';

/// Sincronización remoto → local del catálogo de Pokémon.
///
/// Estrategia (ver docs/adr/0003-paginacion-y-sincronizacion.md):
///
/// * **Paginación offset/limit** ordenada por `id`: el esquema Hasura de
///   PokeAPI no ofrece cursores; con orden estable por id no hay saltos ni
///   repeticiones entre páginas.
/// * **Carga progresiva**: cada página se confirma en una transacción junto
///   con el cursor, así la UI recibe los datos poco a poco desde la base y la
///   sincronización se puede **reanudar** tras una interrupción (PS-07).
/// * **Upsert por id**: repetir la sincronización nunca crea duplicados
///   (PS-06, PA-13) y siempre sobrescribe con la versión remota (OF-19).
/// * **Reintentos** con backoff por página (RNF-RES-02).
class CatalogSyncTask implements SyncTask {
  CatalogSyncTask({
    required PokemonRemoteDataSource remote,
    required PokemonLocalDataSource local,
    required SyncMetadataStore metadataStore,
    int pageSize = AppConfig.catalogPageSize,
    Duration staleAfter = AppConfig.catalogStaleAfter,
    RetryPolicy retryPolicy = const RetryPolicy(),
    DateTime Function()? clock,
  })  : _remote = remote,
        _local = local,
        _store = metadataStore,
        _pageSize = pageSize,
        _staleAfter = staleAfter,
        _retry = retryPolicy,
        _clock = clock ?? DateTime.now;

  /// Clave del recurso en `sync_metadata_entries`.
  static const String key = 'catalog';

  final PokemonRemoteDataSource _remote;
  final PokemonLocalDataSource _local;
  final SyncMetadataStore _store;
  final int _pageSize;
  final Duration _staleAfter;
  final RetryPolicy _retry;
  final DateTime Function() _clock;

  @override
  String get resourceKey => key;

  /// Política de vigencia (PS-03): hace falta sincronizar si nunca se completó,
  /// si la última ejecución quedó a medias/falló, o si pasaron más de
  /// [_staleAfter] desde la última sincronización exitosa.
  @override
  Future<bool> needsSync() async {
    final meta = await _store.read(key);
    if (meta == null || meta.status != SyncStatus.completed) return true;
    final last = meta.lastSuccessAt;
    if (last == null) return true;
    return _clock().difference(last) >= _staleAfter;
  }

  @override
  Future<void> run() async {
    try {
      final meta = await _store.read(key);
      // Reanuda desde el cursor si quedó una ejecución incompleta; si el
      // catálogo estaba completo, es una actualización desde el principio.
      var offset =
          (meta != null && meta.status != SyncStatus.completed) ? meta.cursor : 0;
      await _store.markInProgress(key, cursor: offset);
      appLog('CatalogSync', 'inicio en offset=$offset (páginas de $_pageSize)');

      while (true) {
        final requestOffset = offset;
        final page = await _retry.run(
          () => _remote.fetchCatalogPage(offset: requestOffset, limit: _pageSize),
          isRetryable: (e) => e is RemoteException && e.isRetryable,
          onRetry: (attempt, delay, error) => appLog(
            'CatalogSync',
            'reintento $attempt/${_retry.maxAttempts} de offset=$requestOffset '
            'en ${delay.inMilliseconds} ms (backoff) por: $error',
          ),
        );

        if (requestOffset == 0 && page.isEmpty) {
          // Una primera página vacía no es un catálogo válido: no se marca
          // como completado ni se pierde nada (OF-04).
          throw const InvalidResponseException('La API devolvió un catálogo vacío');
        }

        final isLastPage = page.length < _pageSize;
        final nextOffset = requestOffset + page.length;
        await _local.savePage(
          page,
          resourceKey: key,
          nextCursor: nextOffset,
          completed: isLastPage,
        );
        appLog(
          'CatalogSync',
          'página guardada offset=$requestOffset (${page.length} Pokémon)'
          '${isLastPage ? ' · catálogo completo' : ''}',
        );

        if (isLastPage) return;
        offset = nextOffset;
      }
    } catch (error) {
      try {
        await _store.markFailed(key, error.toString());
      } catch (_) {
        // No ocultar el error original si tampoco se pudo registrar el fallo.
      }
      rethrow;
    }
  }
}
