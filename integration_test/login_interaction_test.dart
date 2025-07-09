import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bankaio/core/routes/router.dart';
import 'package:bankaio/core/firebase/firebase_initializer.dart'; // <-- Importa tu inicializador
import 'package:bankaio/core/config/environment.dart'; // <-- Para saber si usas emuladores

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Widget no encontrado: $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Inicializa Firebase y emuladores si corresponde
    await initializeFirebaseApp(useEmulators: Environment.useFirebaseEmulators);
  });

  group('Login Flow Integration Test', () {
    testWidgets('Simula login completo del usuario', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: appRouter,
          ),
        ),
      );
      await tester.pumpAndSettle();

      print('[TEST] Pantalla de login cargada');

      await pumpUntilFound(tester, find.byKey(const Key('email_field')));
      await tester.enterText(find.byKey(const Key('email_field')), 'ccalispa@yahoo.es');
      await tester.enterText(find.byKey(const Key('password_field')), 'carlitos1001');

      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      await pumpUntilFound(tester, find.byKey(const Key('welcome_home_text')));
      expect(find.byKey(const Key('welcome_home_text')), findsOneWidget);
    });

    // ...otros tests...
  });
}

