import 'package:flutter/foundation.dart';

/// Mecanismo documentado para simular la indisponibilidad de la API con la red
/// activa (PA-08). Se activa desde el menú de depuración de la pantalla del
/// catálogo; mientras vale `true` toda consulta GraphQL falla como un 503.
class ApiSimulation extends ValueNotifier<bool> {
  ApiSimulation() : super(false);
}
