/// Parámetros de configuración documentados en el README (valores de RNF-RES-01,
/// PS-02, PS-03 y PS-04). Se centralizan aquí para poder justificarlos y
/// cambiarlos en un único lugar.
abstract final class AppConfig {
  /// Endpoint GraphQL de PokeAPI (v1beta2: tipos sin el prefijo `pokemon_v2_`).
  static final Uri graphQlEndpoint =
      Uri.parse('https://graphql.pokeapi.co/v1beta2');

  /// Timeout explícito de cada solicitud GraphQL (RNF-RES-01).
  static const Duration requestTimeout = Duration(seconds: 15);

  /// Timeout de la comprobación de salud (más corto: solo valida disponibilidad).
  static const Duration healthCheckTimeout = Duration(seconds: 5);

  /// Tamaño de página del catálogo (paginación por offset/limit, ADR-0003).
  static const int catalogPageSize = 100;

  /// IDs >= 10000 en PokeAPI son formas alternativas (Alola, Mega...). El
  /// catálogo del avance solo incluye las formas por defecto.
  static const int firstAlternateFormId = 10000;

  /// Un catálogo completo se considera desactualizado tras este tiempo (PS-03).
  static const Duration catalogStaleAfter = Duration(hours: 6);

  /// Sincronización periódica mientras el servicio esté disponible (PS-04, OF-20).
  static const Duration periodicSyncInterval = Duration(minutes: 15);

  /// Frecuencia de la comprobación de salud cuando no estamos "online".
  static const Duration healthPollInterval = Duration(seconds: 30);

  /// Cuando estamos online la salud se revalida como mucho cada este tiempo.
  static const Duration healthPollWhenOnline = Duration(minutes: 2);

  /// Antiparpadeo (IND-06): los cambios de red se agrupan durante este tiempo
  /// antes de volver a consultar la API.
  static const Duration connectivityDebounce = Duration(milliseconds: 800);

  /// URLs públicas de imágenes (repositorio PokeAPI/sprites). Se derivan del id.
  static String spriteUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  static String artworkUrl(int id) =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
