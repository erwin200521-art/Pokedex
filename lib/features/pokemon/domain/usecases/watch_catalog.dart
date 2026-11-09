import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

/// Observa el catálogo local.
class WatchCatalog {
  const WatchCatalog(this._repository);

  final PokemonRepository _repository;

  Stream<List<Pokemon>> call() => _repository.watchCatalog();
}
