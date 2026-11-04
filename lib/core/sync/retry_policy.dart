import 'dart:math';

/// Política de reintentos con backoff exponencial, jitter y límite máximo de
/// intentos (RNF-RES-02).
///
/// Con los valores por defecto los reintentos esperan ~1 s, ~2 s (3 intentos
/// en total). El coordinador usa otra instancia con esperas mayores.
class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.multiplier = 2.0,
    this.maxDelay = const Duration(seconds: 30),
    this.jitter = 0.2,
  });

  /// Número máximo de intentos (incluye el primero).
  final int maxAttempts;
  final Duration initialDelay;
  final double multiplier;
  final Duration maxDelay;

  /// Fracción de aleatoriedad (0.2 = ±20 %) para evitar sincronías entre clientes.
  final double jitter;

  static final Random _random = Random();

  /// Espera antes del reintento número [retryNumber] (1 = primer reintento).
  Duration delayFor(int retryNumber, {Random? random}) {
    final exponent = retryNumber < 1 ? 0 : retryNumber - 1;
    final base = initialDelay.inMilliseconds * pow(multiplier, exponent);
    final capped = min(base.toDouble(), maxDelay.inMilliseconds.toDouble());
    final noise = ((random ?? _random).nextDouble() * 2 - 1) * jitter;
    return Duration(milliseconds: (capped * (1 + noise)).round());
  }

  /// Ejecuta [action] reintentando mientras [isRetryable] lo permita y no se
  /// supere [maxAttempts]. El último error se propaga.
  Future<T> run<T>(
    Future<T> Function() action, {
    required bool Function(Object error) isRetryable,
    void Function(int attempt, Duration delay, Object error)? onRetry,
    Future<void> Function(Duration delay)? sleep,
  }) async {
    for (var attempt = 1;; attempt++) {
      try {
        return await action();
      } catch (error) {
        if (attempt >= maxAttempts || !isRetryable(error)) {
          rethrow;
        }
        final delay = delayFor(attempt);
        onRetry?.call(attempt, delay, error);
        if (sleep != null) {
          await sleep(delay);
        } else {
          await Future<void>.delayed(delay);
        }
      }
    }
  }
}
