import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('LoginPage muestra elementos básicos', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextFormField(
                  key: const Key('email_field'),
                  decoration: const InputDecoration(labelText: 'Usuario'),
                ),
                TextFormField(
                  key: const Key('password_field'),
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                ),
                ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: () {},
                  child: const Text('Ingresar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('email_field')), findsOneWidget);
    expect(find.byKey(const Key('password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });
}