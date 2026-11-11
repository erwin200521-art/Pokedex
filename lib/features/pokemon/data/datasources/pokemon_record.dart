import '../../../../core/database/app_database.dart';

/// Fila de Pokémon + nombres de sus tipos, tal como sale de la base local.
/// Es un tipo interno de la capa `data/`; se transforma a la entidad del
/// dominio mediante `PokemonMapper`.
class PokemonRecord {
  PokemonRecord({required this.row}) : typeNames = <String>[];

  final PokemonRow row;

  /// Nombres de tipo ordenados por ranura (se completa al agrupar la consulta).
  final List<String> typeNames;
}
