import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Caché de imágenes en memoria acotada (RNF-REN-04): ~300 imágenes o 80 MB.
  final imageCache = PaintingBinding.instance.imageCache;
  imageCache.maximumSize = 300;
  imageCache.maximumSizeBytes = 80 << 20;

  runApp(ProviderScope(overrides: buildAppOverrides(), child: const PokedexApp()));
}
