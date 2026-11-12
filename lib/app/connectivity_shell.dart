import 'package:flutter/material.dart';

import '../core/widgets/connectivity_indicator.dart';

/// Envuelve TODAS las pantallas con el indicador global en una posición fija
/// y consistente (IND-01): se inyecta en `MaterialApp.builder`.
class ConnectivityShell extends StatelessWidget {
  const ConnectivityShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ConnectivityIndicator(),
        Expanded(
          // El indicador ya respeta el área segura superior: se elimina para
          // que los Scaffold hijos no la apliquen por segunda vez.
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ],
    );
  }
}
