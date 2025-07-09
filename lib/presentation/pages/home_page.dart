import 'package:flutter/material.dart';
import '../../../core/config/environment.dart';
import '../../../core/widgets/logo_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Environment.appName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoWidget(size: 80),
            const SizedBox(height: 20),

            // 👇 Texto que el test busca por clave
            const Text(
              'Bienvenido al Home',
              key: Key('welcome_home_text'),
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Text(
              'Entorno: ${Environment.useFirebaseEmulators ? "Desarrollo" : "Producción"}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Text(
              'API Base: ${Environment.apiBaseUrl}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
