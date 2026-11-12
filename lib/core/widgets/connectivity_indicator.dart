import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_strings.dart';
import '../providers.dart';
import 'connectivity_indicator_data.dart';

/// Indicador global, fijo y reactivo (IND-01 a IND-07).
///
/// * Texto + icono + color: no depende solo del color (IND-05, RNF-ACC-05).
/// * Etiqueta `Semantics` y región "live" para lectores de pantalla (IND-05).
/// * Se actualiza solo ante cambios de red, de API y de sincronización (IND-03).
/// * Sin parpadeos: transiciones animadas y debounce en el monitor (IND-06).
/// * Durante la sincronización muestra una barra fina no intrusiva y no bloquea
///   la navegación (IND-07).
/// * Al tocarlo fuerza una sincronización (objetivo táctil ≥ 48 dp).
class ConnectivityIndicator extends ConsumerWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availability = ref.watch(availabilityProvider);
    final sync = ref.watch(syncStateProvider);
    final lastSync = ref.watch(lastSyncProvider).valueOrNull;

    final data = buildIndicatorData(
      availability: availability,
      sync: sync,
      lastSync: lastSync,
    );
    final palette = _Palette.of(Theme.of(context).brightness, data.kind);
    final canTap = data.kind != IndicatorKind.syncing &&
        data.kind != IndicatorKind.verifying;

    return Semantics(
      container: true,
      liveRegion: true,
      button: canTap,
      label: data.semanticsLabel,
      hint: canTap ? AppStrings.tapToSync : null,
      onTap: canTap ? () => _sync(ref) : null,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          color: palette.background,
          child: SafeArea(
            bottom: false,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: canTap ? () => _sync(ref) : null,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        _KindIcon(kind: data.kind, color: palette.foreground),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                data.title,
                                style: TextStyle(
                                  color: palette.foreground,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                data.detail,
                                style: TextStyle(
                                  color: palette.foreground,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sync(WidgetRef ref) {
    unawaited(
      ref
          .read(syncCoordinatorProvider)
          .syncAll(force: true, reason: 'indicador', resetBackoff: true),
    );
  }
}

class _KindIcon extends StatelessWidget {
  const _KindIcon({required this.kind, required this.color});

  final IndicatorKind kind;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (kind == IndicatorKind.syncing || kind == IndicatorKind.verifying) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
      );
    }
    final icon = switch (kind) {
      IndicatorKind.online => Icons.cloud_done_outlined,
      IndicatorKind.offline => Icons.cloud_off_outlined,
      _ => Icons.warning_amber_rounded,
    };
    return Icon(icon, color: color, size: 20);
  }
}

/// Paletas con contraste ≥ 4.5:1 entre texto y fondo (RNF-ACC-02).
class _Palette {
  const _Palette(this.background, this.foreground);

  final Color background;
  final Color foreground;

  static _Palette of(Brightness brightness, IndicatorKind kind) {
    final dark = brightness == Brightness.dark;
    return switch (kind) {
      IndicatorKind.online => dark
          ? const _Palette(Color(0xFF16361C), Color(0xFFCDEED2))
          : const _Palette(Color(0xFFE3F4E5), Color(0xFF0B3D14)),
      IndicatorKind.syncing => dark
          ? const _Palette(Color(0xFF14304F), Color(0xFFCFE4FF))
          : const _Palette(Color(0xFFDCEBFF), Color(0xFF0A2E63)),
      IndicatorKind.serviceUnavailable => dark
          ? const _Palette(Color(0xFF4A3306), Color(0xFFFFE2A8))
          : const _Palette(Color(0xFFFFE9C7), Color(0xFF4A2F00)),
      IndicatorKind.offline || IndicatorKind.verifying => dark
          ? const _Palette(Color(0xFF2B3138), Color(0xFFE3E7EB))
          : const _Palette(Color(0xFFE4E7EB), Color(0xFF1F2933)),
    };
  }
}
