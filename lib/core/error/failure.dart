/// Fallos del dominio (RNF-CAL-03). Pura Dart: sin Flutter, GraphQL ni Drift.
library;

sealed class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// No hay conectividad.
final class OfflineFailure extends Failure {
  const OfflineFailure([super.message = 'Sin conexión']);
}

/// La API no respondió a tiempo.
final class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Tiempo de espera agotado']);
}

/// Hay red pero la API no responde correctamente (5xx, caída simulada...).
final class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure([super.message = 'Servicio no disponible']);
}

/// HTTP 429.
final class RateLimitFailure extends Failure {
  const RateLimitFailure({this.retryAfter}) : super('Límite de solicitudes');

  final Duration? retryAfter;
}

/// Errores GraphQL, respuestas parciales o cuerpos inválidos.
final class InvalidDataFailure extends Failure {
  const InvalidDataFailure([super.message = 'Datos inválidos']);
}

/// Error de la persistencia local.
final class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Error de almacenamiento']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Error desconocido']);
}
