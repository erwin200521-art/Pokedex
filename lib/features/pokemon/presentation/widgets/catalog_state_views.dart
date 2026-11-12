import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/l10n/app_strings.dart';
import '../state/catalog_ui_state.dart';
import 'failure_message.dart';

/// Contenedor común de los estados sin lista. Es desplazable para que el
/// contenido no se corte con texto al 200 % (RNF-ACC-04).
class _StateScaffold extends StatelessWidget {
  const _StateScaffold({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Estado de carga. En la primera ejecución explica que se puede navegar
/// mientras se descarga (OF-03).
class CatalogLoadingView extends StatelessWidget {
  const CatalogLoadingView({this.downloading = false, super.key});

  final bool downloading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      label: downloading ? AppStrings.downloadingCatalog : null,
      child: _StateScaffold(
        children: [
          const CircularProgressIndicator(),
          if (downloading) ...[
            const SizedBox(height: 24),
            Text(
              AppStrings.downloadingCatalog,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.downloadingCatalogHint,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Estado vacío (ausencia de datos): explica la causa y qué hacer (PA-15).
class CatalogEmptyView extends StatelessWidget {
  const CatalogEmptyView({
    required this.reason,
    required this.onRetry,
    super.key,
  });

  final CatalogEmptyReason reason;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offline = reason == CatalogEmptyReason.offlineNoData;
    return _StateScaffold(
      children: [
        Icon(
          offline ? Icons.cloud_off_outlined : Icons.search_off_outlined,
          size: 64,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(height: 16),
        Text(
          offline ? AppStrings.emptyOfflineTitle : AppStrings.emptyTitle,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          offline ? AppStrings.emptyOfflineHint : AppStrings.emptyHint,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text(AppStrings.retry),
        ),
      ],
    );
  }
}

/// Estado de error con mensaje comprensible y «Reintentar» (RF-CAT-04).
class CatalogErrorView extends StatelessWidget {
  const CatalogErrorView({
    required this.failure,
    required this.onRetry,
    super.key,
  });

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _StateScaffold(
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.errorTitle,
          style: theme.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          failureMessage(failure),
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text(AppStrings.retry),
        ),
      ],
    );
  }
}
