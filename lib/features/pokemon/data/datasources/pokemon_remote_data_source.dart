import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/graphql_client.dart';
import '../dtos/pokemon_dto.dart';
import 'pokemon_graphql_queries.dart';

/// Fuente de datos remota (abstracción sustituible en pruebas, RNF-MAN-03).
abstract interface class PokemonRemoteDataSource {
  /// Descarga una página del catálogo. Lanza [RemoteException] si falla.
  Future<List<PokemonDto>> fetchCatalogPage({
    required int offset,
    required int limit,
  });
}

class GraphQlPokemonRemoteDataSource implements PokemonRemoteDataSource {
  GraphQlPokemonRemoteDataSource(this._client);

  final GraphQlClient _client;

  @override
  Future<List<PokemonDto>> fetchCatalogPage({
    required int offset,
    required int limit,
  }) async {
    final data = await _client.query(
      PokemonGraphQlQueries.catalogPage,
      operationName: PokemonGraphQlQueries.catalogPageOperation,
      variables: {
        'limit': limit,
        'offset': offset,
        'maxId': AppConfig.firstAlternateFormId,
      },
    );

    final raw = data['pokemon'];
    if (raw is! List) {
      throw const InvalidResponseException('Falta la lista "pokemon"');
    }
    try {
      return [
        for (final item in raw)
          PokemonDto.fromJson(Map<String, dynamic>.from(item as Map)),
      ];
    } on RemoteException {
      rethrow;
    } on Object catch (e) {
      throw InvalidResponseException('Lista de Pokémon inválida: $e');
    }
  }
}
