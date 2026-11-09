import '../../../../core/error/result.dart';
import '../repositories/pokemon_repository.dart';

/// Solicita la actualización manual del catálogo («Reintentar», pull-to-refresh).
class RefreshCatalog {
  const RefreshCatalog(this._repository);

  final PokemonRepository _repository;

  Future<Result<void>> call() => _repository.refreshCatalog();
}
