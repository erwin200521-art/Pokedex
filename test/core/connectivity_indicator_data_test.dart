import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/network/connectivity_monitor.dart';
import 'package:pokedex/core/sync/sync_state.dart';
import 'package:pokedex/core/widgets/connectivity_indicator_data.dart';

void main() {
  final lastSync = DateTime(2026, 11, 15, 10, 42);

  group('buildIndicatorData', () {
    test('online sin sincronizar muestra En línea', () {
      final data = buildIndicatorData(
        availability: ServiceAvailability.online,
        sync: const SyncState(),
        lastSync: lastSync,
      );
      expect(data.kind, IndicatorKind.online);
    });

    test('online + sincronizando muestra Sincronizando', () {
      final data = buildIndicatorData(
        availability: ServiceAvailability.online,
        sync: const SyncState(phase: SyncPhase.syncing),
        lastSync: null,
      );
      expect(data.kind, IndicatorKind.syncing);
    });

    test('API caída con red NUNCA se muestra como online (PA-08)', () {
      final data = buildIndicatorData(
        availability: ServiceAvailability.serviceUnavailable,
        sync: const SyncState(),
        lastSync: lastSync,
      );
      expect(data.kind, IndicatorKind.serviceUnavailable);
    });

    test('offline prevalece sobre la sincronización (sin estados contradictorios)',
        () {
      final data = buildIndicatorData(
        availability: ServiceAvailability.offline,
        sync: const SyncState(phase: SyncPhase.syncing),
        lastSync: lastSync,
      );
      expect(data.kind, IndicatorKind.offline);
      expect(data.detail, contains('10:42'));
    });

    test('siempre expone una etiqueta semántica con título y detalle', () {
      final data = buildIndicatorData(
        availability: ServiceAvailability.offline,
        sync: const SyncState(),
        lastSync: null,
      );
      expect(data.semanticsLabel, contains(data.title));
      expect(data.semanticsLabel, contains(data.detail));
    });
  });
}
