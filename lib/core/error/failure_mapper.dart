import 'exceptions.dart';
import 'failure.dart';

/// Traduce cualquier error de infraestructura a un [Failure] del dominio.
Failure mapToFailure(Object error) {
  return switch (error) {
    Failure f => f,
    NetworkException e => OfflineFailure(e.message),
    RequestTimeoutException e => TimeoutFailure(e.message),
    RateLimitedException e => RateLimitFailure(retryAfter: e.retryAfter),
    ServerException e => ServiceUnavailableFailure(e.message),
    GraphQlResponseException e => InvalidDataFailure(e.message),
    InvalidResponseException e => InvalidDataFailure(e.message),
    StorageException e => StorageFailure(e.message),
    _ => UnknownFailure(error.toString()),
  };
}
