import 'dart:async';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/result.dart';
import '../../../../core/network/connectivity_monitor.dart';
import '../../../../core/sync/sync_coordinator.dart';
import '../../../../core/sync/sync_state.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_local_data_source.dart';
import '../mappers/pokemon_mapper.dart';

/// Implementación del repositorio (OF-18).
///
/// * Lectura: SIEMPRE desde la base local (P-01, OF-16, OF-17).
/// * Actualización: delega en el [SyncCoordinator], que escribe en la base y
///   así la UI se entera por la observación local.
/// * Traduce errores de infraestructura a [Failure] del dominio (RNF-CAL-03).
class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl({
    required PokemonLocalDataSource local,
    required SyncCoordinator coordinator,
  })  : _local = local,
        _coordinator = coordinator;

  final PokemonLocalDataSource _local;
  final SyncCoordinator _coordinator;

  @override
  Stream<List<Pokemon>> watchCatalog() {
    return _local
        .watchCatalog()
        .map(
          (records) => records.map(PokemonMapper.toEntity).toList(growable: false),
        )
        .transform(
          StreamTransformer<List<Pokemon>, List<Pokemon>>.fromHandlers(
            handleError: (error, stack, sink) =>
                sink.addError(mapToFailure(error), stack),
          ),
        );
  }

  @override
  Future<Result<void>> refreshCatalog() async {
    final outcome = await _coordinator.syncAll(
      force: true,
      reason: 'actualización manual',
      resetBackoff: true,
    );
    return switch (outcome) {
      SyncCompleted() => const Ok<void>(null),
      SyncSkipped(:final availability) => Err<void>(
          availability == ServiceAvailability.offline
              ? const OfflineFailure()
              : const ServiceUnavailableFailure(),
        ),
      SyncFailed(:final failure) => Err<void>(failure),
    };
  }
}
