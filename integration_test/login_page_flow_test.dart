import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bankaio/main_emuladores.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Carga de pantalla de login', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();

    // Validaciones básicas
    expect(find.text('Usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });
}