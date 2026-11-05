/// Textos de la interfaz centralizados (español). Al añadir la
/// internacionalización completa (RF-COM-05) se migrarán a archivos ARB.
abstract final class AppStrings {
  static const String appTitle = 'Pokédex';
  static const String retry = 'Reintentar';
  static const String syncNow = 'Sincronizar ahora';
  static const String simulateApiDown = 'Simular API caída';
  static const String imageUnavailable = 'Imagen no disponible';

  // Indicador global de conectividad
  static const String verifying = 'Verificando conexión…';
  static const String verifyingDetail = 'Comprobando el servicio';
  static const String online = 'En línea';
  static const String offline = 'Sin conexión';
  static const String unavailable = 'Servicio no disponible';
  static const String unavailableDetail =
      'Red activa, API sin respuesta · datos locales · reintentando automáticamente';
  static const String syncing = 'Sincronizando…';
  static const String syncingDetail = 'En línea · puedes seguir navegando';
  static const String tapToSync = 'Toca para sincronizar';

  // Catálogo
  static const String downloadingCatalog = 'Descargando el catálogo…';
  static const String downloadingCatalogHint =
      'Puedes seguir navegando mientras se descarga.';
  static const String emptyOfflineTitle = 'Aún no hay Pokémon guardados';
  static const String emptyOfflineHint =
      'Conéctate a Internet una vez para descargar el catálogo. '
      'Después podrás usarlo sin conexión.';
  static const String emptyTitle = 'No hay Pokémon para mostrar';
  static const String emptyHint = 'Intenta sincronizar de nuevo.';
  static const String errorTitle = 'No se pudo cargar el catálogo';

  // Mensajes de error comprensibles (RF-CAT-04)
  static const String errorOffline = 'No hay conexión a Internet.';
  static const String errorTimeout =
      'El servidor tardó demasiado en responder.';
  static const String errorUnavailable =
      'El servicio de PokeAPI no está disponible en este momento.';
  static const String errorRateLimit =
      'Demasiadas solicitudes. Intenta de nuevo en unos instantes.';
  static const String errorInvalidData =
      'Se recibieron datos inválidos del servidor.';
  static const String errorStorage =
      'No se pudo leer o guardar la información en el dispositivo.';
  static const String errorUnknown = 'Ocurrió un error inesperado.';

  static String pokedexNumber(int number) =>
      '#${number.toString().padLeft(4, '0')}';

  static String semanticsPokemon(String name, int number, List<String> types) {
    final typeText = types.isEmpty ? 'sin tipo' : 'tipo ${types.join(' y ')}';
    return '$name, Pokédex número $number, $typeText';
  }

  static String lastSync(String time) => 'Datos locales · última sync $time';
  static String remoteUpdated(String time) =>
      'Datos remotos · actualizado $time';
  static const String neverSynced = 'Datos locales · sin sincronizar aún';
}
