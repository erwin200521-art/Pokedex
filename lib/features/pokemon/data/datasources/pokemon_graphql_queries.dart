/// Consultas GraphQL de la funcionalidad Pokémon (PokeAPI v1beta2).
///
/// En v1beta2 se eliminó el prefijo `pokemon_v2_` de los tipos. Verifica los
/// nombres en https://graphql.pokeapi.co/v1beta2/console si la API cambia:
/// este es el ÚNICO lugar que depende del esquema remoto.
abstract final class PokemonGraphQlQueries {
  static const String catalogPageOperation = 'CatalogPage';

  /// Página del catálogo por offset/limit, ordenada por id (estable) y limitada
  /// a las formas por defecto (`id < 10000`).
  static const String catalogPage = r'''
query CatalogPage($limit: Int!, $offset: Int!, $maxId: Int!) {
  pokemon(
    where: { id: { _lt: $maxId } }
    order_by: { id: asc }
    limit: $limit
    offset: $offset
  ) {
    id
    name
    height
    weight
    pokemontypes(order_by: { slot: asc }) {
      slot
      type {
        id
        name
      }
    }
  }
}
''';
}
