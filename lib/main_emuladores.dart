import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/router.dart';
import 'core/theme/theme.dart';
import 'core/config/environment.dart';
import 'core/bootstrap/firebase_env_initializer.dart';
import 'core/auth/auth_listener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseWithEnv(useEmulators: true); // Emuladores

  runApp(const ProviderScope(child: BankaioApp()));
}

class BankaioApp extends StatelessWidget {
  const BankaioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthListener(
      child: MaterialApp.router(
        title: Environment.appName,
        debugShowCheckedModeBanner: Environment.showDebugBanner,
        theme: AppTheme.theme,
        routerConfig: appRouter,
      ),
    );
  }
}

