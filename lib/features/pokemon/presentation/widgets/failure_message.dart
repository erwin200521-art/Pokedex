import '../../../../core/error/failure.dart';
import '../../../../core/l10n/app_strings.dart';

/// Mensaje comprensible para el usuario según el tipo de fallo (RF-CAT-04).
String failureMessage(Failure failure) {
  return switch (failure) {
    OfflineFailure() => AppStrings.errorOffline,
    TimeoutFailure() => AppStrings.errorTimeout,
    ServiceUnavailableFailure() => AppStrings.errorUnavailable,
    RateLimitFailure() => AppStrings.errorRateLimit,
    InvalidDataFailure() => AppStrings.errorInvalidData,
    StorageFailure() => AppStrings.errorStorage,
    UnknownFailure() => AppStrings.errorUnknown,
  };
}
