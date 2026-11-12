import '../l10n/app_strings.dart';
import '../network/connectivity_monitor.dart';
import '../sync/sync_state.dart';

enum IndicatorKind { verifying, online, offline, serviceUnavailable, syncing }

/// Datos de presentación del indicador global. Compone las dos dimensiones
/// (disponibilidad + sincronización) con el origen y la vigencia de los datos
/// (IND-04, §7.4).
class IndicatorData {
  const IndicatorData({
    required this.kind,
    required this.title,
    required this.detail,
  });

  final IndicatorKind kind;
  final String title;
  final String detail;

  String get semanticsLabel => '$title. $detail';
}

IndicatorData buildIndicatorData({
  required ServiceAvailability availability,
  required SyncState sync,
  required DateTime? lastSync,
}) {
  switch (availability) {
    case ServiceAvailability.verifying:
      return const IndicatorData(
        kind: IndicatorKind.verifying,
        title: AppStrings.verifying,
        detail: AppStrings.verifyingDetail,
      );
    case ServiceAvailability.offline:
      return IndicatorData(
        kind: IndicatorKind.offline,
        title: AppStrings.offline,
        detail: _localDetail(lastSync),
      );
    case ServiceAvailability.serviceUnavailable:
      // Nunca se muestra "online" si la API no responde (PA-08).
      return const IndicatorData(
        kind: IndicatorKind.serviceUnavailable,
        title: AppStrings.unavailable,
        detail: AppStrings.unavailableDetail,
      );
    case ServiceAvailability.online:
      if (sync.isSyncing) {
        return const IndicatorData(
          kind: IndicatorKind.syncing,
          title: AppStrings.syncing,
          detail: AppStrings.syncingDetail,
        );
      }
      final detail = sync.syncedThisSession && lastSync != null
          ? AppStrings.remoteUpdated(formatTime(lastSync))
          : _localDetail(lastSync);
      return IndicatorData(
        kind: IndicatorKind.online,
        title: AppStrings.online,
        detail: detail,
      );
  }
}

String _localDetail(DateTime? lastSync) {
  return lastSync == null
      ? AppStrings.neverSynced
      : AppStrings.lastSync(formatTime(lastSync));
}

String formatTime(DateTime time) {
  final local = time.toLocal();
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}
