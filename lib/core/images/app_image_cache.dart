import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Caché de imágenes en disco (PS-08, OF-08).
///
/// * Qué se guarda: los sprites del catálogo y, más adelante, el artwork de los
///   detalles abiertos. Se descargan bajo demanda al mostrarse.
/// * Límite: 1500 archivos (los sprites pesan ~3-5 KB: < 10 MB en total).
/// * Limpieza: expiran a los 180 días y, al superar el límite, se eliminan los
///   menos usados (política LRU de `flutter_cache_manager`).
/// * Offline: un archivo vigente se sirve del disco sin consultar la red.
abstract final class AppImageCache {
  static final CacheManager instance = CacheManager(
    Config(
      'pokedexImages',
      stalePeriod: const Duration(days: 180),
      maxNrOfCacheObjects: 1500,
    ),
  );
}
