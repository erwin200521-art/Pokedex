import '../../../../core/config/app_config.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/pokemon.dart';
import '../datasources/pokemon_record.dart';
import '../dtos/pokemon_dto.dart';

/// Mapeadores DTO → fila Drift y fila Drift → entidad del dominio.
abstract final class PokemonMapper {
  static PokemonsCompanion toCompanion(PokemonDto dto, DateTime now) {
    return PokemonsCompanion.insert(
      id: dto.id,
      name: dto.name,
      // En PokeAPI el id de un Pokémon por defecto coincide con su número de
      // Pokédex nacional (las formas alternativas se filtran con id < 10000).
      nationalDexNumber: dto.id,
      height: dto.height,
      weight: dto.weight,
      spriteUrl: AppConfig.spriteUrl(dto.id),
      artworkUrl: AppConfig.artworkUrl(dto.id),
      updatedAt: now,
    );
  }

  static Pokemon toEntity(PokemonRecord record) {
    final row = record.row;
    return Pokemon(
      id: row.id,
      name: row.name,
      nationalDexNumber: row.nationalDexNumber,
      types: record.typeNames,
      spriteUrl: row.spriteUrl,
      artworkUrl: row.artworkUrl,
    );
  }
}
