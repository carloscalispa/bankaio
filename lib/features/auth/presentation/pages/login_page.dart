import 'package:bankaio/core/config/environment.dart';
import 'package:bankaio/features/auth/presentation/providers/auth_provider.dart';
import 'package:bankaio/features/auth/presentation/providers/auth_state.dart';
import 'package:bankaio/features/auth/presentation/providers/login_page_flow.dart';
import 'package:bankaio/features/auth/presentation/providers/login_attempts_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
  import 'package:flutter/services.dart';
  import 'package:go_router/go_router.dart';

class LoginPage extends HookConsumerWidget {
  Future<void> _closeAppAndFirebase(BuildContext context) async {
    try {
      await Firebase.app().delete();
    } catch (_) {}
    await Future.delayed(const Duration(milliseconds: 500));
    // Cerrar la app completamente
    Future.microtask(() => SystemNavigator.pop());
  }
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isObscured = useState(true);
    final loginState = ref.watch(loginProvider);
    final flow = LoginPageFlow(ref); // Instancia flujo

    // Estado para habilitar/deshabilitar el botón de login
    final isButtonEnabled = useState(false);

    // Estado de intentos y bloqueo
    final attempts = ref.watch(loginAttemptsProvider);
    final blocked = ref.watch(loginBlockedProvider);

    // Cerrar app y Firebase si los intentos superan el límite
    useEffect(() {
      if (attempts > 2 && !blocked) {
        Future.microtask(() => _closeAppAndFirebase(context));
      }
      return null;
    }, [attempts, blocked]);

    // Listener para los campos de texto
    useEffect(() {
      void listener() {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        isButtonEnabled.value = email.isNotEmpty && password.isNotEmpty;
      }

      emailController.addListener(listener);
      passwordController.addListener(listener);

      // Inicializar el estado al montar
      listener();

      return () {
        emailController.removeListener(listener);
        passwordController.removeListener(listener);
      };
    }, [emailController, passwordController]);

    if (loginState is LoginSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    } else if (loginState is LoginError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${loginState.message}')),
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('email_field'),
                    controller: emailController,
                    enabled: !blocked,
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
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    key: const Key('password_field'),
                    controller: passwordController,
                    obscureText: isObscured.value,
                    enabled: !blocked,
                    decoration: InputDecoration(
                      hintText: '********',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscured.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: !blocked ? () => isObscured.value = !isObscured.value : null,
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  if (blocked)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Acceso bloqueado. Debe restablecer la contraseña.',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Intentos restantes: 0',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  else if (attempts > 0 && attempts <= 3)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Intentos restantes: ${3 - attempts}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    key: const Key('login_button'),
                    onPressed:
                        flow.isLoading(loginState) || !isButtonEnabled.value || blocked
                        ? null
                        : () {
                            if (attempts < 3) {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              flow.login(email, password);
                              final notifier = ref.read(loginAttemptsProvider.notifier);
                              notifier.state = attempts + 1;
                            }
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
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/register'),
                    child: const Text(
                      "¿No tienes cuenta? Regístrate",
                      style: TextStyle(color: Colors.white),
                    ),
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
