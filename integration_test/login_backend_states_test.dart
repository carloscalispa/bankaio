import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bankaio/main_emuladores.dart' as app;
import 'package:bankaio/core/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  int attempts = 0;
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      debugPrint('✅ Widget encontrado: $finder');
      return;
    }
    if (attempts % 10 == 0) {
      debugPrint('⏳ Esperando widget: $finder...');
    }
    attempts++;
  }
  throw TestFailure('❌ Widget no encontrado: $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    print('🔧 Inicializando Firebase con emuladores...');
    await initializeFirebaseApp(useEmulators: true);
    print('✅ Firebase inicializado');
  });

  group('Login Backend States Integration Test', () {
    testWidgets('Login exitoso navega a home', (tester) async {
      print('🚀 Iniciando test: Login exitoso navega a home');
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await pumpUntilFound(tester, find.byKey(const Key('email_field')));
      await tester.enterText(find.byKey(const Key('email_field')), 'ccalispa@yahoo.es');
      await tester.enterText(find.byKey(const Key('password_field')), 'carlitos1001');

      await pumpUntilFound(tester, find.byKey(const Key('login_button')));
      await tester.tap(find.byKey(const Key('login_button')));

      await tester.pump(); // inicia navegación
      await tester.pumpAndSettle(const Duration(seconds: 10)); // espera navegación

      await pumpUntilFound(tester, find.byKey(const Key('welcome_home_text')), timeout: const Duration(seconds: 10));
      expect(find.byKey(const Key('welcome_home_text')), findsOneWidget);
      print('✅ Test de login exitoso pasó');
    });

    testWidgets('Login con campos vacíos muestra error', (tester) async {
      print('🚀 Iniciando test: Login con campos vacíos');
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await pumpUntilFound(tester, find.byKey(const Key('login_button')));
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      print('✅ Test de campos vacíos pasó');
    });

    testWidgets('Login con contraseña incorrecta muestra error', (tester) async {
      print('🚀 Iniciando test: Login con contraseña incorrecta');
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await pumpUntilFound(tester, find.byKey(const Key('email_field')));
      await tester.enterText(find.byKey(const Key('email_field')), 'ccalispa@yahoo.es');
      await tester.enterText(find.byKey(const Key('password_field')), 'incorrecta');

      await pumpUntilFound(tester, find.byKey(const Key('login_button')));
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      print('✅ Test de contraseña incorrecta pasó');
    });
  });
}
