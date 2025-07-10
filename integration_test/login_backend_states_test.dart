import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bankaio/main_emuladores.dart' as app;
import 'package:bankaio/core/firebase/firebase_initializer.dart';
import 'package:bankaio/core/test_helpers/auth_test_helper.dart';
import 'package:flutter/material.dart';

/// Función helper mejorada para esperar widgets con mejor logging y manejo de errores
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 15),
  String? description,
}) async {
  final end = DateTime.now().add(timeout);
  int attempts = 0;
  final desc = description ?? finder.toString();
  
  debugPrint('🔍 Buscando widget: $desc');
  
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      debugPrint('✅ Widget encontrado: $desc');
      return;
    }
    if (attempts % 20 == 0) {
      debugPrint('⏳ Esperando widget ($attempts intentos): $desc');
    }
    attempts++;
  }
  
  // Logging adicional para debugging
  debugPrint('❌ Widget no encontrado después de $attempts intentos: $desc');
  debugPrint('🔍 Widgets disponibles:');
  final allWidgets = find.byType(Widget);
  for (final element in allWidgets.evaluate().take(10)) {
    debugPrint('  - ${element.widget.runtimeType}');
  }
  
  throw TestFailure('❌ Widget no encontrado después de ${timeout.inSeconds}s: $desc');
}

/// Helper para esperar que no haya widgets de carga
Future<void> waitForNoLoadingIndicators(WidgetTester tester) async {
  await tester.pumpAndSettle();
  const maxWait = Duration(seconds: 10);
  final endTime = DateTime.now().add(maxWait);
  
  while (DateTime.now().isBefore(endTime)) {
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      debugPrint('✅ No hay indicadores de carga');
      return;
    }
    debugPrint('⏳ Esperando que termine la carga...');
    await tester.pump(const Duration(milliseconds: 500));
  }
  
  debugPrint('⚠️ Timeout esperando que termine la carga');
}

/// Helper para verificar que aparezca un SnackBar con mensaje específico
Future<void> expectSnackBarWithMessage(
  WidgetTester tester, 
  String expectedMessage, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  debugPrint('🔍 Esperando SnackBar con mensaje: "$expectedMessage"');
  
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
    
    final snackBars = find.byType(SnackBar);
    if (snackBars.evaluate().isNotEmpty) {
      final snackBarFinder = find.descendant(
        of: snackBars.first,
        matching: find.textContaining(expectedMessage),
      );
      
      if (snackBarFinder.evaluate().isNotEmpty) {
        debugPrint('✅ SnackBar encontrado con mensaje esperado');
        return;
      }
    }
  }
  
  throw TestFailure('❌ SnackBar con mensaje "$expectedMessage" no encontrado');
}

/// Helper para verificar que estamos en la pantalla de login
Future<void> ensureLoginScreen(WidgetTester tester) async {
  debugPrint('🔍 Verificando que estamos en pantalla de login...');
  
  // Buscar elementos clave de la pantalla de login
  final usuarioText = find.text('Usuario');
  final passwordText = find.text('Contraseña');
  final loginButton = find.byKey(const Key('login_button'));
  
  // Si ya estamos en login, salir
  if (usuarioText.evaluate().isNotEmpty && 
      passwordText.evaluate().isNotEmpty && 
      loginButton.evaluate().isNotEmpty) {
    debugPrint('✅ Ya estamos en pantalla de login');
    return;
  }
  
  // Verificar si estamos en home y necesitamos hacer logout
  final homeText = find.text('Bienvenido al Home');
  if (homeText.evaluate().isNotEmpty) {
    debugPrint('🔄 Estamos en Home, forzando logout...');
    await forceLogoutAndNavigateToLogin(tester);
  } else {
    // Si no estamos ni en home ni en login, reiniciar la app
    debugPrint('🔄 Estado desconocido, reiniciando app...');
    await restartApp(tester);
  }
  
  // Verificar que ahora estamos en login
  await pumpUntilFound(
    tester, 
    usuarioText, 
    timeout: const Duration(seconds: 15),
    description: 'Texto Usuario en login'
  );
  
  await pumpUntilFound(
    tester, 
    passwordText, 
    timeout: const Duration(seconds: 5),
    description: 'Texto Contraseña en login'
  );
  
  debugPrint('✅ Confirmado que estamos en pantalla de login');
}

/// Helper para limpiar el estado de la app entre tests
Future<void> clearAppState(WidgetTester tester) async {
  debugPrint('🧹 Limpiando estado de la app...');
  await tester.pumpAndSettle();
  // Cerrar cualquier SnackBar abierto
  if (find.byType(SnackBar).evaluate().isNotEmpty) {
    await tester.pump(const Duration(seconds: 4)); // SnackBars se cierran solos
  }
  await tester.pumpAndSettle();
}

/// Helper para reiniciar la aplicación y volver a login
Future<void> restartApp(WidgetTester tester) async {
  debugPrint('🔄 Reiniciando aplicación...');
  
  // Limpiar estado de autenticación primero
  await AuthTestHelper.clearAuthState();
  
  // Esperar a que el estado de autenticación se propague
  await AuthTestHelper.waitForAuthStateChange();
  
  debugPrint('🔄 Reiniciando aplicación main...');
  
  // Reiniciar la app
  await app.main();
  
  // Esperar mucho más tiempo para que la app se inicialice y el AuthListener procese el cambio
  await tester.pumpAndSettle(const Duration(seconds: 5));
  
  // Hacer pumps adicionales para procesar el estado de autenticación
  for (int i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    
    // Verificar si tenemos elementos de login
    final usuarioText = find.text('Usuario');
    final passwordText = find.text('Contraseña');
    
    if (usuarioText.evaluate().isNotEmpty && passwordText.evaluate().isNotEmpty) {
      debugPrint('✅ Aplicación reiniciada exitosamente - Login detectado en pump $i');
      return;
    }
    
    // Verificar si estamos en home (lo que no queremos)
    final homeText = find.text('Bienvenido al Home');
    if (homeText.evaluate().isNotEmpty) {
      debugPrint('⚠️ Aún en Home en pump $i, continuando...');
    }
  }
  
  debugPrint('⚠️ No se detectó login después de reiniciar, pero continuando...');
}

/// Helper para forzar logout y navegar a login
Future<void> forceLogoutAndNavigateToLogin(WidgetTester tester) async {
  debugPrint('🔄 Forzando logout y navegación a login...');
  
  // Hacer logout
  await AuthTestHelper.clearAuthState();
  
  // Esperar que el AuthListener procese el cambio y usar el router redirect
  await tester.pumpAndSettle(const Duration(seconds: 2));
  
  // Reiniciar la app para forzar que el router haga redirect
  await app.main();
  await tester.pumpAndSettle(const Duration(seconds: 3));
  
  // Hacer pumps para permitir navegación
  for (int i = 0; i < 50; i++) {
    await tester.pump(const Duration(milliseconds: 200));
    
    final usuarioText = find.text('Usuario');
    if (usuarioText.evaluate().isNotEmpty) {
      debugPrint('✅ Navegación a login exitosa en pump $i');
      return;
    }
    
    // Verificar si seguimos en home
    final homeText = find.text('Bienvenido al Home');
    if (homeText.evaluate().isNotEmpty && i % 10 == 0) {
      debugPrint('⚠️ Aún en Home en pump $i, continuando...');
    }
  }
  
  debugPrint('⚠️ No se pudo navegar a login después del logout');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    debugPrint('🔧 Inicializando Firebase con emuladores...');
    await initializeFirebaseApp(useEmulators: true);
    debugPrint('✅ Firebase inicializado');
    
    // Verificar conexión con emuladores
    await AuthTestHelper.verifyEmulatorConnection();
    
    // Limpiar cualquier estado previo
    await AuthTestHelper.clearAuthState();
    debugPrint('✅ Estado inicial limpiado');
  });

  group('Login Backend States Integration Test', () {
    setUp(() async {
      debugPrint('🔄 Configurando test...');
      // Limpiar estado de autenticación antes de cada test
      await AuthTestHelper.clearAuthState();
      await Future.delayed(const Duration(milliseconds: 500));
    });

    tearDown(() async {
      debugPrint('🧹 Limpiando después del test...');
      // Limpiar estado de autenticación después de cada test
      await AuthTestHelper.clearAuthState();
      await Future.delayed(const Duration(milliseconds: 500));
    });

    testWidgets('Login exitoso navega a home', (tester) async {
      debugPrint('🚀 Iniciando test: Login exitoso navega a home');
      await ensureLoginScreen(tester);

      // Verificar que estamos en la pantalla de login
      await pumpUntilFound(
        tester, 
        find.text('Usuario'), 
        description: 'Texto Usuario en login'
      );
      await pumpUntilFound(
        tester, 
        find.text('Contraseña'), 
        description: 'Texto Contraseña en login'
      );

      // Encontrar y llenar campos
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('email_field')),
        description: 'Campo de email'
      );
      await tester.enterText(find.byKey(const Key('email_field')), 'ccalispa@yahoo.es');
      
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('password_field')),
        description: 'Campo de contraseña'
      );
      await tester.enterText(find.byKey(const Key('password_field')), 'carlitos1001');

      // Presionar botón de login
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('login_button')),
        description: 'Botón de login'
      );
      
      // Verificar que el botón dice "Ingresar"
      expect(find.text('Ingresar'), findsOneWidget);
      
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump(const Duration(milliseconds: 500)); // Iniciar navegación

      // Esperar proceso de autenticación con debugging mejorado
      debugPrint('⏳ Esperando proceso de autenticación...');
      bool loginSuccessful = false;
      
      // Aumentar timeout y mejorar el manejo
      for (int attempt = 0; attempt < 30; attempt++) { // 30 segundos máximo
        await tester.pump(const Duration(seconds: 1));
        
        // Verificar si ya estamos en home
        final homeText = find.byKey(const Key('welcome_home_text'));
        if (homeText.evaluate().isNotEmpty) {
          debugPrint('✅ Login exitoso detectado en intento $attempt');
          loginSuccessful = true;
          break;
        }
        
        // Verificar si hubo error
        final errorSnackBar = find.byType(SnackBar);
        if (errorSnackBar.evaluate().isNotEmpty) {
          debugPrint('❌ Error detectado durante el login en intento $attempt');
          // Obtener texto del error
          final snackBarText = find.descendant(
            of: errorSnackBar.first,
            matching: find.byType(Text),
          );
          if (snackBarText.evaluate().isNotEmpty) {
            final textWidget = snackBarText.first.evaluate().first.widget as Text;
            debugPrint('Error: ${textWidget.data}');
          }
          throw TestFailure('❌ Error durante el login');
        }
        
        // Log del progreso cada 5 segundos
        if (attempt % 5 == 0) {
          debugPrint('⏳ Esperando... ($attempt/30 segundos)');
          
          // Verificar si hay indicadores de carga
          final loadingIndicators = find.byType(CircularProgressIndicator);
          if (loadingIndicators.evaluate().isNotEmpty) {
            debugPrint('  - Indicador de carga presente');
          }
        }
      }
      
      if (!loginSuccessful) {
        debugPrint('❌ Login no completado después de 30 segundos');
        debugPrint('🔍 Estado final del árbol de widgets:');
        final allTexts = find.byType(Text);
        for (final element in allTexts.evaluate().take(15)) {
          final textWidget = element.widget as Text;
          final textData = textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
          debugPrint('  - "$textData"');
        }
        
        throw TestFailure('❌ No se pudo completar el login en 30 segundos');
      }

      // Verificar navegación exitosa a home
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('welcome_home_text')), 
        timeout: const Duration(seconds: 5),
        description: 'Texto de bienvenida en home'
      );
      
      // Verificaciones adicionales en home
      expect(find.byKey(const Key('welcome_home_text')), findsOneWidget);
      expect(find.text('Bienvenido al Home'), findsOneWidget);
      
      debugPrint('✅ Test de login exitoso pasó');
    });

    testWidgets('Login con campos vacíos muestra error específico', (tester) async {
      debugPrint('🚀 Iniciando test: Login con campos vacíos');
      await ensureLoginScreen(tester);

      // Verificar que estamos en la pantalla de login
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('login_button')),
        description: 'Botón de login'
      );
      
      // Presionar login sin llenar campos
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar que aparece un SnackBar con error
      expect(find.byType(SnackBar), findsOneWidget);
      
      // Esperar a que el SnackBar desaparezca
      await clearAppState(tester);
      debugPrint('✅ Test de campos vacíos pasó');
    });

    testWidgets('Login con contraseña incorrecta muestra error específico', (tester) async {
      debugPrint('🚀 Iniciando test: Login con contraseña incorrecta');
      await ensureLoginScreen(tester);

      // Llenar campos con datos incorrectos
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('email_field')),
        description: 'Campo de email'
      );
      await tester.enterText(find.byKey(const Key('email_field')), 'ccalispa@yahoo.es');
      
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('password_field')),
        description: 'Campo de contraseña'
      );
      await tester.enterText(find.byKey(const Key('password_field')), 'contraseña_incorrecta');

      await pumpUntilFound(
        tester, 
        find.byKey(const Key('login_button')),
        description: 'Botón de login'
      );
      await tester.tap(find.byKey(const Key('login_button')));
      
      // Esperar que termine el proceso de autenticación
      await waitForNoLoadingIndicators(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que aparece error
      expect(find.byType(SnackBar), findsOneWidget);
      
      // Verificar que NO navegamos a home (seguimos en login)
      expect(find.byKey(const Key('welcome_home_text')), findsNothing);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      
      await clearAppState(tester);
      debugPrint('✅ Test de contraseña incorrecta pasó');
    });

    testWidgets('Login con email inválido muestra error de validación', (tester) async {
      debugPrint('🚀 Iniciando test: Login con email inválido');
      await ensureLoginScreen(tester);

      // Llenar campos con email inválido
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('email_field')),
        description: 'Campo de email'
      );
      await tester.enterText(find.byKey(const Key('email_field')), 'email_invalido');
      
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('password_field')),
        description: 'Campo de contraseña'
      );
      await tester.enterText(find.byKey(const Key('password_field')), 'cualquier_password');

      await pumpUntilFound(
        tester, 
        find.byKey(const Key('login_button')),
        description: 'Botón de login'
      );
      await tester.tap(find.byKey(const Key('login_button')));
      
      await waitForNoLoadingIndicators(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verificar que aparece error y NO navegamos
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.byKey(const Key('welcome_home_text')), findsNothing);
      
      await clearAppState(tester);
      debugPrint('✅ Test de email inválido pasó');
    });

    testWidgets('Interfaz de login contiene todos los elementos esperados', (tester) async {
      debugPrint('🚀 Iniciando test: Verificación de interfaz completa');
      await ensureLoginScreen(tester);

      // Verificar elementos de la interfaz
      expect(find.text('Usuario'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Ingresar'), findsOneWidget);
      expect(find.text('¿Olvidaste tu contraseña?'), findsOneWidget);
      expect(find.text('¿No tienes cuenta? Regístrate'), findsOneWidget);
      
      // Verificar campos por key
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      
      // Verificar que el campo de contraseña está oculto inicialmente
      final passwordField = tester.widget<TextField>(find.byKey(const Key('password_field')));
      expect(passwordField.obscureText, isTrue);
      
      // Verificar logo
      expect(find.byType(Image), findsOneWidget);
      
      debugPrint('✅ Test de interfaz completa pasó');
    });

    testWidgets('Toggle de visibilidad de contraseña funciona', (tester) async {
      debugPrint('🚀 Iniciando test: Toggle de visibilidad de contraseña');
      await ensureLoginScreen(tester);

      // Encontrar el campo de contraseña
      await pumpUntilFound(
        tester, 
        find.byKey(const Key('password_field')),
        description: 'Campo de contraseña'
      );
      
      // Verificar que inicialmente está oculto
      TextField passwordField = tester.widget<TextField>(find.byKey(const Key('password_field')));
      expect(passwordField.obscureText, isTrue);
      
      // Encontrar y presionar el botón de visibilidad
      final visibilityButton = find.descendant(
        of: find.byKey(const Key('password_field')),
        matching: find.byType(IconButton),
      );
      expect(visibilityButton, findsOneWidget);
      
      await tester.tap(visibilityButton);
      await tester.pump();
      
      // Verificar que ahora está visible
      passwordField = tester.widget<TextField>(find.byKey(const Key('password_field')));
      expect(passwordField.obscureText, isFalse);
      
      // Presionar de nuevo para ocultarlo
      await tester.tap(visibilityButton);
      await tester.pump();
      
      passwordField = tester.widget<TextField>(find.byKey(const Key('password_field')));
      expect(passwordField.obscureText, isTrue);
      
      debugPrint('✅ Test de toggle de visibilidad pasó');
    });
  });
}
