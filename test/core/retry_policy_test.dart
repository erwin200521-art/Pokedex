import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/core/sync/retry_policy.dart';

void main() {
  group('RetryPolicy', () {
    test('reintenta con backoff exponencial hasta tener éxito', () async {
      const policy = RetryPolicy(jitter: 0);
      final delays = <Duration>[];
      var calls = 0;

      final result = await policy.run<String>(
        () async {
          calls++;
          if (calls < 3) throw StateError('falla $calls');
          return 'ok';
        },
        isRetryable: (_) => true,
        sleep: (d) async => delays.add(d),
      );

      expect(result, 'ok');
      expect(calls, 3);
      expect(delays, [const Duration(seconds: 1), const Duration(seconds: 2)]);
    });

    test('respeta el máximo de intentos y propaga el último error', () async {
      const policy = RetryPolicy(maxAttempts: 3, jitter: 0);
      var calls = 0;

      await expectLater(
        policy.run<void>(
          () async {
            calls++;
            throw StateError('siempre falla');
          },
          isRetryable: (_) => true,
          sleep: (_) async {},
        ),
        throwsStateError,
      );
      expect(calls, 3);
    });

    test('no reintenta errores no recuperables', () async {
      const policy = RetryPolicy();
      var calls = 0;

      await expectLater(
        policy.run<void>(
          () async {
            calls++;
            throw ArgumentError('datos inválidos');
          },
          isRetryable: (_) => false,
          sleep: (_) async {},
        ),
        throwsArgumentError,
      );
      expect(calls, 1);
    });

    test('la espera nunca supera maxDelay', () {
      const policy = RetryPolicy(
        initialDelay: Duration(seconds: 1),
        maxDelay: Duration(seconds: 5),
        jitter: 0,
      );
      expect(policy.delayFor(10), const Duration(seconds: 5));
    });
  });
}
