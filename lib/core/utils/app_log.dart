import 'package:flutter/foundation.dart';

/// Registro en consola. Se usa como evidencia en la demostración
/// (consultas GraphQL, reintentos con backoff, decisiones de sincronización).
void appLog(String tag, String message) {
  debugPrint('[$tag] $message');
}
