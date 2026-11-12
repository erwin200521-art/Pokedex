import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/app_strings.dart';
import '../core/providers.dart';
import '../core/theme/app_theme.dart';
import '../features/pokemon/presentation/pages/catalog_page.dart';
import 'connectivity_shell.dart';

class PokedexApp extends ConsumerWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Crea y arranca el coordinador (monitor de conectividad + sincronización).
    // No espera nada: la interfaz aparece de inmediato (OF-03, PA-01).
    ref.watch(syncCoordinatorProvider);

    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      builder: (context, child) => ConnectivityShell(child: child!),
      home: const CatalogPage(),
    );
  }
}
