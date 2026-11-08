import 'dart:async';

import '../config/app_config.dart';
import '../error/failure.dart';
import '../error/failure_mapper.dart';
import '../network/connectivity_monitor.dart';
import '../utils/app_log.dart';
import 'retry_policy.dart';
import 'sync_state.dart';
import 'sync_task.dart';

/// Orquesta la sincronización remoto → local de todas las [SyncTask].
///
/// * Se dispara al iniciar, al recuperar conectividad, de forma periódica y
///   manualmente (PS-04, OF-20).
/// * Evita ejecuciones concurrentes: una segunda solicitud comparte el Future
///   de la que está en curso (RNF-RES-03).
/// * Ante un fallo programa reintentos automáticos con backoff exponencial y
///   límite máximo (RNF-RES-02, D3 §3.2); después espera a un evento
///   (reconexión, periodo o acción manual).
/// * No bloquea la UI: todo es asíncrono y la UI solo observa la base local.
class SyncCoordinator {
  SyncCoordinator({
    required List<SyncTask> tasks,
    required ConnectivityMonitor monitor,
    RetryPolicy retryPolicy = const RetryPolicy(
      maxAttempts: 5,
      initialDelay: Duration(seconds: 15),
      maxDelay: Duration(minutes: 5),
    ),
    Duration periodicInterval = AppConfig.periodicSyncInterval,
    DateTime Function()? clock,
  })  : _tasks = List.unmodifiable(tasks),
        _monitor = monitor,
        _retryPolicy = retryPolicy,
        _periodicInterval = periodicInterval,
        _clock = clock ?? DateTime.now;

  final List<SyncTask> _tasks;
  final ConnectivityMonitor _monitor;
  final RetryPolicy _retryPolicy;
  final Duration _periodicInterval;
  final DateTime Function() _clock;

  final StreamController<SyncState> _controller =
      StreamController<SyncState>.broadcast();

  SyncState _state = const SyncState();
  Future<SyncOutcome>? _inFlight;
  Timer? _retryTimer;
  Timer? _periodicTimer;
  StreamSubscription<ServiceAvailability>? _availabilitySub;
  int _autoRetryAttempt = 0;
  bool _started = false;

  SyncState get state => _state;
  Stream<SyncState> get states => _controller.stream;

  /// Arranca el monitor de conectividad y los disparadores automáticos.
  void start() {
    if (_started) return;
    _started = true;

    _monitor.start();
    _availabilitySub = _monitor.changes.listen((availability) {
      if (availability == ServiceAvailability.online) {
        unawaited(syncAll(reason: 'conectividad recuperada', resetBackoff: true));
      }
    });
    _periodicTimer = Timer.periodic(
      _periodicInterval,
      (_) => unawaited(syncAll(reason: 'periódica')),
    );
    unawaited(syncAll(reason: 'inicio de la aplicación'));
  }

  /// Sincroniza todas las tareas pendientes. Con [force] ignora la vigencia de
  /// los datos (actualización manual).
  Future<SyncOutcome> syncAll({
    bool force = false,
    String reason = 'manual',
    bool resetBackoff = false,
  }) {
    if (force || resetBackoff) _autoRetryAttempt = 0;
    final running = _inFlight;
    if (running != null) return running;
    final future = _run(force: force, reason: reason);
    _inFlight = future.whenComplete(() => _inFlight = null);
    return _inFlight!;
  }

  Future<SyncOutcome> _run({required bool force, required String reason}) async {
    _retryTimer?.cancel();
    _retryTimer = null;

    final availability = await _monitor.check();
    if (availability != ServiceAvailability.online) {
      appLog('Sync', 'omitida ($reason): servicio $availability');
      return SyncSkipped(availability);
    }

    try {
      final pending = <SyncTask>[];
      for (final task in _tasks) {
        if (force || await task.needsSync()) pending.add(task);
      }
      if (pending.isEmpty) {
        appLog('Sync', 'nada pendiente ($reason): datos vigentes');
        if (_state.phase != SyncPhase.idle) {
          _emit(SyncState(syncedThisSession: _state.syncedThisSession));
        }
        return const SyncCompleted();
      }

      appLog('Sync', 'inicio ($reason): ${pending.map((t) => t.resourceKey).join(', ')}');
      _emit(
        SyncState(
          phase: SyncPhase.syncing,
          syncedThisSession: _state.syncedThisSession,
          lastFailure: _state.lastFailure,
          retryAttempt: _autoRetryAttempt,
        ),
      );

      for (final task in pending) {
        await task.run();
      }

      _autoRetryAttempt = 0;
      _emit(const SyncState(syncedThisSession: true));
      appLog('Sync', 'completada ($reason)');
      return const SyncCompleted();
    } catch (error) {
      final failure = mapToFailure(error);
      appLog('Sync', 'falló ($reason): $failure');
      // El fallo puede deberse a que la API cayó: refresca el indicador.
      unawaited(_monitor.check());
      return _handleFailure(failure);
    }
  }

  SyncOutcome _handleFailure(Failure failure) {
    _autoRetryAttempt++;

    if (_autoRetryAttempt > _retryPolicy.maxAttempts) {
      appLog('Sync', 'reintentos automáticos agotados; se espera un evento');
      _emit(
        SyncState(
          phase: SyncPhase.failed,
          syncedThisSession: _state.syncedThisSession,
          lastFailure: failure,
          retryAttempt: _autoRetryAttempt - 1,
        ),
      );
      return SyncFailed(failure);
    }

    var delay = _retryPolicy.delayFor(_autoRetryAttempt);
    if (failure is RateLimitFailure) {
      final retryAfter = failure.retryAfter;
      if (retryAfter != null && retryAfter > delay) delay = retryAfter;
    }

    appLog(
      'Sync',
      'reintento automático $_autoRetryAttempt/${_retryPolicy.maxAttempts} '
      'en ${delay.inSeconds} s',
    );
    _emit(
      SyncState(
        phase: SyncPhase.waitingRetry,
        syncedThisSession: _state.syncedThisSession,
        lastFailure: failure,
        retryAttempt: _autoRetryAttempt,
        nextRetryAt: _clock().add(delay),
      ),
    );
    _retryTimer = Timer(
      delay,
      () => unawaited(syncAll(reason: 'reintento automático $_autoRetryAttempt')),
    );
    return SyncFailed(failure);
  }

  void _emit(SyncState next) {
    _state = next;
    if (!_controller.isClosed) _controller.add(next);
  }

  void dispose() {
    _retryTimer?.cancel();
    _periodicTimer?.cancel();
    unawaited(_availabilitySub?.cancel());
    unawaited(_controller.close());
  }
}
