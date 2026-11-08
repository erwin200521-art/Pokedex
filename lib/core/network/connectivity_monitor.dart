import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../config/app_config.dart';
import '../utils/app_log.dart';
import 'graphql_client.dart';

/// Dimensión 1 del modelo de estados (D3, §3.1): disponibilidad del servicio.
///
/// Es independiente del estado de sincronización (ver `SyncState`); así se
/// evitan estados contradictorios como "offline" + "API accesible" (§7.4).
enum ServiceAvailability {
  /// Aún no se ha completado la primera comprobación.
  verifying,

  /// Hay red y la API GraphQL responde.
  online,

  /// No hay conectividad de red.
  offline,

  /// Hay red, pero la API no responde correctamente.
  serviceUnavailable,
}

/// Determina la disponibilidad *real* del servicio (IND-02, OF-11):
///
/// 1. `connectivity_plus` indica si hay alguna interfaz de red.
/// 2. Si la hay, se hace una consulta GraphQL mínima (`ServiceHealthProbe`).
///
/// Se vuelve a comprobar ante cambios de red (con debounce, IND-06) y de forma
/// periódica.
class ConnectivityMonitor {
  ConnectivityMonitor({
    required Connectivity connectivity,
    required ServiceHealthProbe probe,
    Duration debounce = AppConfig.connectivityDebounce,
    Duration pollInterval = AppConfig.healthPollInterval,
    Duration pollWhenOnline = AppConfig.healthPollWhenOnline,
  })  : _connectivity = connectivity,
        _probe = probe,
        _debounce = debounce,
        _pollInterval = pollInterval,
        _pollWhenOnline = pollWhenOnline;

  final Connectivity _connectivity;
  final ServiceHealthProbe _probe;
  final Duration _debounce;
  final Duration _pollInterval;
  final Duration _pollWhenOnline;

  final StreamController<ServiceAvailability> _controller =
      StreamController<ServiceAvailability>.broadcast();

  ServiceAvailability _current = ServiceAvailability.verifying;
  Future<ServiceAvailability>? _inFlight;
  DateTime _lastCheck = DateTime.fromMillisecondsSinceEpoch(0);
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _debounceTimer;
  Timer? _pollTimer;
  bool _started = false;

  ServiceAvailability get current => _current;

  /// Emite solo cuando el estado cambia.
  Stream<ServiceAvailability> get changes => _controller.stream;

  void start() {
    if (_started) return;
    _started = true;

    _subscription = _connectivity.onConnectivityChanged.listen((_) {
      // Antiparpadeo: agrupa ráfagas de eventos de red.
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounce, () => unawaited(check()));
    });

    _pollTimer = Timer.periodic(_pollInterval, (_) {
      final sinceLast = DateTime.now().difference(_lastCheck);
      if (_current != ServiceAvailability.online || sinceLast >= _pollWhenOnline) {
        unawaited(check());
      }
    });

    unawaited(check());
  }

  /// Comprueba ahora mismo la disponibilidad. Las llamadas concurrentes
  /// comparten la misma comprobación en curso.
  Future<ServiceAvailability> check() {
    return _inFlight ??= _check().whenComplete(() => _inFlight = null);
  }

  Future<ServiceAvailability> _check() async {
    var hasNetwork = true;
    try {
      final results = await _connectivity.checkConnectivity();
      hasNetwork = results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      // Si la plataforma no puede informar, se decide con la sonda a la API.
    }

    final ServiceAvailability next;
    if (!hasNetwork) {
      next = ServiceAvailability.offline;
    } else {
      final reachable = await _probe.isReachable();
      next = reachable
          ? ServiceAvailability.online
          : ServiceAvailability.serviceUnavailable;
    }

    _lastCheck = DateTime.now();
    _update(next);
    return next;
  }

  void _update(ServiceAvailability next) {
    if (next == _current) return;
    appLog('Connectivity', '$_current → $next');
    _current = next;
    if (!_controller.isClosed) _controller.add(next);
  }

  void dispose() {
    _debounceTimer?.cancel();
    _pollTimer?.cancel();
    unawaited(_subscription?.cancel());
    unawaited(_controller.close());
  }
}
