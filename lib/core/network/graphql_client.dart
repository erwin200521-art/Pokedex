import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../utils/app_log.dart';
import 'api_simulation.dart';

/// Comprueba si el servicio remoto responde de verdad (IND-02): no basta con
/// que haya Wi-Fi o datos móviles.
abstract interface class ServiceHealthProbe {
  Future<bool> isReachable();
}

/// Cliente GraphQL mínimo sobre HTTP POST (ADR-0004).
///
/// * Timeout explícito en cada solicitud (RNF-RES-01).
/// * Errores diferenciados: red, timeout, 429, 5xx, errores GraphQL y
///   respuestas parciales (RNF-RES-05).
/// * El JSON se decodifica en un isolate para no ocupar el hilo de UI
///   (RNF-REN-03).
class GraphQlClient implements ServiceHealthProbe {
  GraphQlClient({
    required http.Client httpClient,
    required Uri endpoint,
    required ApiSimulation simulation,
    Duration timeout = AppConfig.requestTimeout,
  })  : _http = httpClient,
        _endpoint = endpoint,
        _simulation = simulation,
        _timeout = timeout;

  final http.Client _http;
  final Uri _endpoint;
  final ApiSimulation _simulation;
  final Duration _timeout;

  /// Ejecuta una consulta y devuelve el objeto `data`.
  ///
  /// Lanza subtipos de [RemoteException]; nunca devuelve datos si la respuesta
  /// contiene errores GraphQL (incluidas las respuestas parciales).
  Future<Map<String, dynamic>> query(
    String document, {
    Map<String, dynamic>? variables,
    String? operationName,
    Duration? timeout,
    bool log = true,
  }) async {
    final effectiveTimeout = timeout ?? _timeout;
    final label = operationName ?? 'anonymous';
    if (log) appLog('GraphQL', '→ $label ${variables ?? const {}}');

    if (_simulation.value) {
      if (log) appLog('GraphQL', '✗ $label: API simulada como no disponible');
      throw const ServerException(503, 'API no disponible (simulación activa)');
    }

    final stopwatch = Stopwatch()..start();
    final http.Response response;
    try {
      response = await _http
          .post(
            _endpoint,
            headers: const {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: jsonEncode({
              'query': document,
              'variables': variables ?? const <String, dynamic>{},
              if (operationName != null) 'operationName': operationName,
            }),
          )
          .timeout(effectiveTimeout);
    } on TimeoutException {
      throw RequestTimeoutException(
        'Tiempo de espera agotado (${effectiveTimeout.inSeconds} s)',
      );
    } on IOException catch (e) {
      throw NetworkException(e.toString());
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }

    final status = response.statusCode;
    if (log) {
      appLog('GraphQL', '← $label HTTP $status en ${stopwatch.elapsedMilliseconds} ms');
    }

    if (status == 429) {
      throw RateLimitedException(
        'Límite de solicitudes alcanzado (HTTP 429)',
        retryAfter: _parseRetryAfter(response.headers['retry-after']),
      );
    }
    if (status >= 500) {
      throw ServerException(status, 'HTTP $status');
    }

    final decoded = await _decode(response.bodyBytes);
    if (decoded is! Map) {
      throw const InvalidResponseException('La respuesta no es un objeto JSON');
    }

    final errors = decoded['errors'];
    if (errors is List && errors.isNotEmpty) {
      // Con `data` presente sería una respuesta parcial: se descarta entera.
      throw GraphQlResponseException(
        _firstErrorMessage(errors),
        hasPartialData: decoded['data'] != null,
      );
    }
    if (status < 200 || status >= 300) {
      throw ServerException(status, 'HTTP $status');
    }

    final data = decoded['data'];
    if (data is! Map) {
      throw const InvalidResponseException('La respuesta no contiene "data"');
    }
    return Map<String, dynamic>.from(data);
  }

  @override
  Future<bool> isReachable() async {
    try {
      await query(
        'query Health { pokemon(limit: 1) { id } }',
        operationName: 'Health',
        timeout: AppConfig.healthCheckTimeout,
        log: false,
      );
      return true;
    } on RemoteException {
      return false;
    }
  }

  Future<Object?> _decode(List<int> bytes) async {
    try {
      return await Isolate.run<Object?>(() => jsonDecode(utf8.decode(bytes)));
    } catch (_) {
      throw const InvalidResponseException('JSON inválido');
    }
  }

  String _firstErrorMessage(List<dynamic> errors) {
    final first = errors.first;
    if (first is Map && first['message'] is String) {
      return first['message'] as String;
    }
    return 'Error GraphQL';
  }

  Duration? _parseRetryAfter(String? header) {
    final seconds = int.tryParse(header ?? '');
    return seconds == null ? null : Duration(seconds: seconds);
  }
}
