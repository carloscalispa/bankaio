import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthTestHelper {
  static Future<void> forceLogout() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseAuth.instance.signOut();
        if (kDebugMode) {
          debugPrint('🔄 AuthTestHelper: Logout forzado exitoso para usuario: ${currentUser.email ?? 'Sin email'}');
        }
      } else {
        if (kDebugMode) {
          debugPrint('🔄 AuthTestHelper: No hay usuario logueado');
        }
      }
      // Verificar que realmente se hizo logout
      final afterLogout = FirebaseAuth.instance.currentUser;
      if (afterLogout == null) {
        if (kDebugMode) {
          debugPrint('✅ AuthTestHelper: Estado de autenticación limpiado exitosamente');
        }
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ AuthTestHelper: Usuario aún presente después del logout');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AuthTestHelper: Error en logout forzado: $e');
      }
    }
  }

  static Future<void> clearAuthState() async {
    await forceLogout();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> waitForAuthStateChange() async {
    const maxWait = Duration(seconds: 5);
    final startTime = DateTime.now();
    while (DateTime.now().difference(startTime) < maxWait) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          debugPrint('✅ AuthTestHelper: Estado de autenticación cambiado');
        }
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (kDebugMode) {
      debugPrint('⚠️ AuthTestHelper: Timeout esperando cambio de estado de autenticación');
    }
  }

  static Future<void> verifyEmulatorConnection() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (kDebugMode) {
        debugPrint('🔍 Estado actual de Firebase Auth:');
        debugPrint('  - Usuario actual: ${currentUser?.email ?? 'No hay usuario'}');
        debugPrint('  - App configurada: ${FirebaseAuth.instance.app.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error verificando conexión con emuladores: $e');
      }
    }
  }

  static Future<void> forceAppRestart() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 AuthTestHelper: Forzando reinicio de aplicación');
      }
      await clearAuthState();
      await Future.delayed(const Duration(milliseconds: 200));
      if (kDebugMode) {
        debugPrint('✅ AuthTestHelper: Reinicio completado');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AuthTestHelper: Error durante reinicio: $e');
      }
    }
  }
}
