import '../../../../core/error/result.dart';
import '../entities/pokemon.dart';

/// Contrato del repositorio (OF-18). La implementación vive en `data/`.
abstract interface class PokemonRepository {
  /// Catálogo observable desde la base local (OF-16). Emite cada vez que la
  /// sincronización modifica los datos; nunca depende de una respuesta remota.
  Stream<List<Pokemon>> watchCatalog();

  /// Solicita una actualización remoto → local. La UI no espera el resultado
  /// para mostrar datos: solo lo usa para informar errores.
  Future<Result<void>> refreshCatalog();
}
