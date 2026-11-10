import '../../../../core/error/exceptions.dart';

/// DTO de un Pokémon tal como lo devuelve la consulta GraphQL del catálogo.
/// No sale de la capa `data/` (no se expone a presentación).
class PokemonDto {
  const PokemonDto({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
  });

  final int id;
  final String name;
  final int height;
  final int weight;
  final List<PokemonTypeDto> types;

  /// Valida estrictamente la estructura: un campo faltante o con tipo
  /// incorrecto invalida TODA la página (no se persisten datos a medias).
  factory PokemonDto.fromJson(Map<String, dynamic> json) {
    try {
      final rawTypes = (json['pokemontypes'] as List?) ?? const [];
      return PokemonDto(
        id: json['id'] as int,
        name: json['name'] as String,
        height: (json['height'] as int?) ?? 0,
        weight: (json['weight'] as int?) ?? 0,
        types: [
          for (final raw in rawTypes)
            PokemonTypeDto.fromJson(Map<String, dynamic>.from(raw as Map)),
        ],
      );
    } on Object catch (e) {
      throw InvalidResponseException('Pokémon con estructura inválida: $e');
    }
  }
}

class PokemonTypeDto {
  const PokemonTypeDto({
    required this.typeId,
    required this.name,
    required this.slot,
  });

  final int typeId;
  final String name;
  final int slot;

  factory PokemonTypeDto.fromJson(Map<String, dynamic> json) {
    final type = Map<String, dynamic>.from(json['type'] as Map);
    return PokemonTypeDto(
      typeId: type['id'] as int,
      name: type['name'] as String,
      slot: json['slot'] as int,
    );
  }
}
