/// Entidad del dominio. Pura Dart: no conoce Flutter, GraphQL ni Drift.
class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.nationalDexNumber,
    required this.types,
    required this.spriteUrl,
    required this.artworkUrl,
  });

  final int id;
  final String name;

  /// Número de Pokédex nacional.
  final int nationalDexNumber;

  /// Uno o dos tipos, en orden de ranura.
  final List<String> types;

  /// Miniatura para el listado.
  final String spriteUrl;

  /// Imagen oficial para el detalle (la usará la entrega final).
  final String artworkUrl;
}
