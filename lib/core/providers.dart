import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'config/app_config.dart';
import 'database/app_database.dart';
import 'database/drift_sync_metadata_store.dart';
import 'network/api_simulation.dart';
import 'network/connectivity_monitor.dart';
import 'network/graphql_client.dart';
import 'sync/sync_coordinator.dart';
import 'sync/sync_metadata.dart';
import 'sync/sync_state.dart';
import 'sync/sync_task.dart';

/// Proveedores de infraestructura transversal (inyección de dependencias,
/// RNF-MAN-03). Todos son sustituibles mediante `ProviderScope.overrides`.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final apiSimulationProvider = Provider<ApiSimulation>((ref) {
  final simulation = ApiSimulation();
  ref.onDispose(simulation.dispose);
  return simulation;
});

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final graphQlClientProvider = Provider<GraphQlClient>((ref) {
  return GraphQlClient(
    httpClient: ref.watch(httpClientProvider),
    endpoint: AppConfig.graphQlEndpoint,
    simulation: ref.watch(apiSimulationProvider),
  );
});

final connectivityMonitorProvider = Provider<ConnectivityMonitor>((ref) {
  final monitor = ConnectivityMonitor(
    connectivity: Connectivity(),
    probe: ref.watch(graphQlClientProvider),
  );
  ref.onDispose(monitor.dispose);
  return monitor;
});

final syncMetadataStoreProvider = Provider<SyncMetadataStore>((ref) {
  return DriftSyncMetadataStore(ref.watch(appDatabaseProvider));
});

/// Tareas de sincronización registradas por las funcionalidades. Por defecto
/// vacío; la composición (`app/bootstrap.dart`) lo sobrescribe, de modo que
/// `core/` no depende de ninguna feature.
final syncTasksProvider = Provider<List<SyncTask>>((ref) => const []);

final syncCoordinatorProvider = Provider<SyncCoordinator>((ref) {
  final coordinator = SyncCoordinator(
    tasks: ref.watch(syncTasksProvider),
    monitor: ref.watch(connectivityMonitorProvider),
  );
  ref.onDispose(coordinator.dispose);
  coordinator.start();
  return coordinator;
});

/// Disponibilidad del servicio como estado de Riverpod. El estado inicial se
/// lee tras suscribirse, así no se pierde ningún evento.
final availabilityProvider =
    NotifierProvider<AvailabilityNotifier, ServiceAvailability>(
  AvailabilityNotifier.new,
);

class AvailabilityNotifier extends Notifier<ServiceAvailability> {
  @override
  ServiceAvailability build() {
    final monitor = ref.watch(connectivityMonitorProvider);
    final subscription = monitor.changes.listen((value) => state = value);
    ref.onDispose(subscription.cancel);
    return monitor.current;
  }
}

/// Estado de sincronización como estado de Riverpod.
final syncStateProvider =
    NotifierProvider<SyncStateNotifier, SyncState>(SyncStateNotifier.new);

class SyncStateNotifier extends Notifier<SyncState> {
  @override
  SyncState build() {
    final coordinator = ref.watch(syncCoordinatorProvider);
    final subscription = coordinator.states.listen((value) => state = value);
    ref.onDispose(subscription.cancel);
    return coordinator.state;
  }
}

/// Fecha de la última sincronización exitosa persistida (IND-04, PS-09).
final lastSyncProvider = StreamProvider<DateTime?>((ref) {
  return ref.watch(syncMetadataStoreProvider).watchLastSuccess();
});
