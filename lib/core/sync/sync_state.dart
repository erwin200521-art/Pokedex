import '../error/failure.dart';
import '../network/connectivity_monitor.dart';

/// Dimensión 2 del modelo de estados (D3, §3.2): actividad de sincronización.
enum SyncPhase {
  /// Sin actividad.
  idle,

  /// Descargando / actualizando la base local.
  syncing,

  /// Falló; hay un reintento automático programado (backoff).
  waitingRetry,

  /// Falló y se agotaron los reintentos automáticos.
  failed,
}

class SyncState {
  const SyncState({
    this.phase = SyncPhase.idle,
    this.syncedThisSession = false,
    this.lastFailure,
    this.retryAttempt = 0,
    this.nextRetryAt,
  });

  final SyncPhase phase;

  /// Si ya hubo una sincronización exitosa en esta sesión (datos "remotos
  /// actualizados" frente a "datos locales", IND-04).
  final bool syncedThisSession;
  final Failure? lastFailure;
  final int retryAttempt;
  final DateTime? nextRetryAt;

  bool get isSyncing => phase == SyncPhase.syncing;
}

/// Resultado de una solicitud de sincronización.
sealed class SyncOutcome {
  const SyncOutcome();
}

/// Terminó correctamente (o no había nada pendiente).
final class SyncCompleted extends SyncOutcome {
  const SyncCompleted();
}

/// No se ejecutó porque el servicio no está disponible.
final class SyncSkipped extends SyncOutcome {
  const SyncSkipped(this.availability);

  final ServiceAvailability availability;
}

final class SyncFailed extends SyncOutcome {
  const SyncFailed(this.failure);

  final Failure failure;
}
