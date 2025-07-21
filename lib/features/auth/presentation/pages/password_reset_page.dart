import 'package:bankaio/core/services/email_validator.dart';
import 'package:bankaio/features/auth/presentation/providers/password_reset_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bankaio/features/auth/presentation/providers/login_attempts_provider.dart';

class PasswordResetPage extends HookConsumerWidget {
  const PasswordResetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final isSubmitting = ref.watch(passwordResetProvider);

    final mounted = useRef(true);

    useEffect(() {
      return () {
        mounted.value = false;
      };
    }, []);

    // Capturar mensajero y navigator al inicio del build
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    return Scaffold(
      key: const ValueKey('reset_password_page'),
      appBar: AppBar(title: const Text("Recuperar contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Ingresa tu correo para recuperar tu contraseña"),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      final email = emailController.text.trim();

                      if (!EmailValidator.isValid(email)) {
                        if (mounted.value) {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Correo inválido')),
                          );
                        }
                        return;
                      }

                      final result = await ref
                          .read(passwordResetProvider.notifier)
                          .sendResetEmail(email);
                      // Desbloquear login si estaba bloqueado
                      ref.read(loginAttemptsProvider.notifier).state = 0;
                      ref.read(loginBlockedProvider.notifier).state = false;

                      if (!mounted.value) return;

                      final isDev =
                          const String.fromEnvironment('FLUTTER_ENV') ==
                              'development';

                      if (result == null) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              isDev
                                  ? 'Correo simulado enviado (emulador - no se enviará correo real).'
                                  : 'Correo de recuperación enviado. Revisa tu bandeja.',
                            ),
                          ),
                        );
                        navigator.pop(); // <- Usamos navigator local
                      } else {
                        messenger.showSnackBar(
                          SnackBar(content: Text(result)),
                        );
                      }
                    },
              child: isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enviar enlace'),
            ),
          ],
        ),
      ),
    );
  }
}
