import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import '../features/pokemon/pokemon_providers.dart';

/// Raíz de composición: registra en el coordinador de sincronización las
/// tareas de cada funcionalidad. Al añadir favoritos, trivia, etc. basta con
/// agregar su tarea aquí; `core/` no cambia.
List<Override> buildAppOverrides() {
  return [
    syncTasksProvider.overrideWith(
      (ref) => [ref.watch(catalogSyncTaskProvider)],
    ),
  ];
}
