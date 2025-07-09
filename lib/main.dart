
import 'package:bankaio/main_emuladores.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


Future<void> pumpUntilFound(WidgetTester tester, Finder finder,
    {Duration timeout = const Duration(seconds: 10)}) async {
  final endTime = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(endTime)) {
    await tester.pump();
    if (tester.any(finder)) {
      print('✅ Widget encontrado: ${finder.toString()}');
      return;
    }
    print('⏳ Esperando widget: ${finder.toString()}...');
    await Future.delayed(const Duration(milliseconds: 200));
  }
  throw TestFailure('❌ Widget no encontrado: ${finder.toString()}');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    print('🔧 Inicializando Firebase con emuladores...');
    // Aquí va tu inicialización real o emuladores
    // await initializeFirebaseWithEnv(useEmulators: true);
    print('✅ Firebase inicializado');
  });

  tearDownAll(() async {
    print('🔧 Limpiando después de tests...');
    // Aquí va limpieza si necesitas
  });

  testWidgets('Login exitoso navega a home', (tester) async {
    print('🚀 Test: Login exitoso navega a home');
    await tester.pumpWidget(const ProviderScope(child: BankaioApp()));

    // Esperamos que el campo email esté disponible
    await pumpUntilFound(tester, find.byKey(const Key('email_field')));

    // Simulamos ingresar email y contraseña válidos
    await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password123');

    // Esperamos que el botón login esté visible
    await pumpUntilFound(tester, find.byKey(const Key('login_button')));

    // Pulsamos el botón login
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Verificamos que el texto de bienvenida en Home aparece
    await pumpUntilFound(tester, find.byKey(const Key('welcome_home_text')));
  });

  testWidgets('Login con campos vacíos muestra error', (tester) async {
    print('🚀 Test: Login con campos vacíos');
    await tester.pumpWidget(const ProviderScope(child: BankaioApp()));

    await pumpUntilFound(tester, find.byKey(const Key('login_button')));

    // Pulsamos el botón login sin llenar campos
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Verificamos que muestra error
    await pumpUntilFound(tester, find.textContaining('Por favor completa todos los campos'));
  });

  testWidgets('Login con contraseña incorrecta muestra error', (tester) async {
    print('🚀 Test: Login con contraseña incorrecta');
    await tester.pumpWidget(const ProviderScope(child: BankaioApp()));

    await pumpUntilFound(tester, find.byKey(const Key('email_field')));
    await pumpUntilFound(tester, find.byKey(const Key('password_field')));
    await pumpUntilFound(tester, find.byKey(const Key('login_button')));

    // Ingresamos email válido y contraseña incorrecta
    await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();

    // Verificamos que aparece mensaje de error contraseña incorrecta
    await pumpUntilFound(tester, find.textContaining('Contraseña incorrecta'));
  });
}
