import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/result.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers.dart';
import '../../pokemon_providers.dart';
import '../state/catalog_providers.dart';
import '../state/catalog_ui_state.dart';
import '../widgets/catalog_state_views.dart';
import '../widgets/failure_message.dart';
import '../widgets/pokemon_list_view.dart';

/// Pantalla del catálogo (RF-CAT-01, RF-CAT-04). Solo observa el estado derivado
/// de la base local; no conoce GraphQL ni Drift (§8.1).
class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(catalogUiStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: const [_DebugMenu()],
      ),
      body: switch (state) {
        CatalogLoading(:final downloading) =>
          CatalogLoadingView(downloading: downloading),
        CatalogLoaded(:final pokemon) => RefreshIndicator(
            onRefresh: () => _refresh(context, ref),
            child: PokemonListView(pokemon: pokemon),
          ),
        CatalogEmpty(:final reason) => CatalogEmptyView(
            reason: reason,
            onRetry: () => unawaited(_refresh(context, ref)),
          ),
        CatalogError(:final failure) => CatalogErrorView(
            failure: failure,
            onRetry: () => unawaited(_refresh(context, ref)),
          ),
      },
    );
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(refreshCatalogProvider)();
    if (result case Err<void>(:final failure)) {
      messenger.showSnackBar(SnackBar(content: Text(failureMessage(failure))));
    }
  }
}

/// Menú de depuración: sincronización manual (PS-04) y simulación de caída de
/// la API con red activa (PA-08).
class _DebugMenu extends ConsumerWidget {
  const _DebugMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulation = ref.watch(apiSimulationProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: simulation,
      builder: (context, apiDown, _) => PopupMenuButton<String>(
        tooltip: 'Menú de depuración',
        onSelected: (value) {
          switch (value) {
            case 'sync':
              unawaited(
                ref.read(syncCoordinatorProvider).syncAll(
                      force: true,
                      reason: 'menú',
                      resetBackoff: true,
                    ),
              );
            case 'simulate':
              simulation.value = !simulation.value;
              // Re-evalúa la disponibilidad real al instante; al volver a
              // estar online el coordinador sincroniza por sí solo.
              unawaited(ref.read(connectivityMonitorProvider).check());
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem<String>(
            value: 'sync',
            child: Text(AppStrings.syncNow),
          ),
          CheckedPopupMenuItem<String>(
            value: 'simulate',
            checked: apiDown,
            child: const Text(AppStrings.simulateApiDown),
          ),
        ],
      ),
    );
  }
}
