// lib/core/config/environment_prod.dart
class EnvironmentProd {
  static const bool useFirebaseEmulators = false;
  static const String firestoreHost = 'localhost:8080';
  static const String authHost = 'localhost';
  static const int authPort = 9099;
  static const String appName = 'Bankaio Producción';
  static const String apiBaseUrl = 'https://api.bankaio.com';
  static const bool showDebugBanner = false;
  static const String themeColorHex = '#00A86B'; // 🟩 Verde producción
}
