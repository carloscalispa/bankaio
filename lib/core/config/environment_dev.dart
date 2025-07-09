// lib/core/config/environment_dev.dart
class EnvironmentDev {
  static const bool useFirebaseEmulators = true;
  static const String firestoreHost = 'localhost:8080';
  static const String authHost = 'localhost';
  static const int authPort = 9099;
  static const String appName = 'Bankaio Desarrollo';
  static const String apiBaseUrl = 'http://localhost:3000';
  static const bool showDebugBanner = true;
  static const String themeColorHex = '#1E88E5'; // 🟦 Azul desarrollo
}
