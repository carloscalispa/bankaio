import 'package:bankaio/core/config/environment.dart';
import 'package:bankaio/features/auth/presentation/providers/auth_provider.dart';
import 'package:bankaio/features/auth/presentation/providers/auth_state.dart';
import 'package:bankaio/features/auth/presentation/providers/login_page_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isObscured = useState(true);
    final loginState = ref.watch(loginProvider);
    final flow = LoginPageFlow(ref);  // Instancia flujo

    if (loginState is LoginSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    } else if (loginState is LoginError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginState.message)),
        );
      });
    }

    final themeColor = _parseColor(Environment.themeColorHex);

    return Scaffold(
      backgroundColor: themeColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/BankAio.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Usuario",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('email_field'), // <-- Clave añadida
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'correo@ejemplo.com',
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Contraseña",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('password_field'), // <-- Clave añadida
                    controller: passwordController,
                    obscureText: isObscured.value,
                    decoration: InputDecoration(
                      hintText: '********',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscured.value ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => isObscured.value = !isObscured.value,
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    key: const Key('login_button'), // <-- Clave añadida
                    onPressed: flow.isLoading(loginState)
                        ? null
                        : () {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            flow.login(email, password);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: flow.isLoading(loginState)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Ingresar"),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.push('/reset-password'),
                    child: const Text("¿Olvidaste tu contraseña?", style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implementar navegación a registro
                    },
                    child: const Text("¿No tienes cuenta? Regístrate", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
