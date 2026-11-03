/// Excepciones de infraestructura. Se lanzan en la capa de datos / core y se
/// traducen a [Failure] (tipos del dominio) mediante `mapToFailure`.
library;

/// Error al hablar con el servicio remoto.
sealed class RemoteException implements Exception {
  const RemoteException(this.message);

  final String message;

  /// Si tiene sentido reintentar la operación (RNF-RES-02).
  bool get isRetryable;

  @override
  String toString() => '$runtimeType: $message';
}

/// Sin conectividad o conexión interrumpida.
final class NetworkException extends RemoteException {
  const NetworkException(super.message);

  @override
  bool get isRetryable => true;
}

/// La solicitud superó el timeout configurado (RNF-RES-01).
final class RequestTimeoutException extends RemoteException {
  const RequestTimeoutException(super.message);

  @override
  bool get isRetryable => true;
}

/// HTTP 429: limitación de tasa.
final class RateLimitedException extends RemoteException {
  const RateLimitedException(super.message, {this.retryAfter});

  final Duration? retryAfter;

  @override
  bool get isRetryable => true;
}

/// Errores 5xx del servidor (o simulación de caída de la API).
final class ServerException extends RemoteException {
  const ServerException(this.statusCode, super.message);

  final int statusCode;

  @override
  bool get isRetryable => true;
}

/// La API respondió con un arreglo `errors` de GraphQL. Si además trae `data`
/// (respuesta parcial) NO se persiste: se descarta completa (OF-04).
final class GraphQlResponseException extends RemoteException {
  const GraphQlResponseException(super.message, {this.hasPartialData = false});

  final bool hasPartialData;

  @override
  bool get isRetryable => false;
}

/// Cuerpo no interpretable (JSON inválido, estructura inesperada).
final class InvalidResponseException extends RemoteException {
  const InvalidResponseException(super.message);

  @override
  bool get isRetryable => false;
}

/// Error de la base de datos local.
final class StorageException implements Exception {
  const StorageException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'StorageException: $message';
}
