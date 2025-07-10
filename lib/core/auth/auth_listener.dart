// 📁 lib/core/auth/auth_listener.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthListener extends StatefulWidget {
  final Widget child;

  const AuthListener({super.key, required this.child});

  @override
  State<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener> {
  late final Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
    
    // Escuchar cambios de estado de autenticación
    _authStateChanges.listen((User? user) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            try {
              // Verificar si tenemos un GoRouter disponible
              final router = GoRouter.maybeOf(context);
              if (router != null) {
                final currentRoute = GoRouterState.of(context).uri.path;
                
                if (user == null) {
                  // Usuario se deslogueó, navegar a login
                  if (currentRoute != '/') {
                    debugPrint('AuthListener: Redirigiendo a login desde $currentRoute');
                    context.go('/');
                  }
                } else {
                  // Usuario logueado, si está en login navegar a home
                  if (currentRoute == '/') {
                    debugPrint('AuthListener: Usuario logueado, redirigiendo a home');
                    context.go('/home');
                  }
                }
              }
            } catch (e) {
              // Si no hay GoRouter disponible, no hacer nada
              debugPrint('AuthListener: Error navegando - $e');
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
