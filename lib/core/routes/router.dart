import 'package:bankaio/features/auth/presentation/pages/login_page.dart';
import 'package:bankaio/features/auth/presentation/pages/password_reset_page.dart';
import 'package:go_router/go_router.dart';
import 'package:bankaio/presentation/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    final isLoggingIn = state.uri.path == '/';
    
    // Si no está logueado y no está en login, redirigir a login
    if (!isLoggedIn && !isLoggingIn) {
      return '/';
    }
    
    return null; // No redirigir
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const PasswordResetPage(),
    ),
    // Puedes agregar más rutas aquí...
  ],
);


