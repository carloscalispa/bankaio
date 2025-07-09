// lib/core/config/environment.dart

import 'environment_dev.dart';
import 'environment_prod.dart';

class Environment {
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get useFirebaseEmulators => _env == 'dev'
      ? EnvironmentDev.useFirebaseEmulators
      : EnvironmentProd.useFirebaseEmulators;

  static String get firestoreHost => _env == 'dev'
      ? EnvironmentDev.firestoreHost
      : EnvironmentProd.firestoreHost;

  static String get authHost => _env == 'dev'
      ? EnvironmentDev.authHost
      : EnvironmentProd.authHost;

  static int get authPort => _env == 'dev'
      ? EnvironmentDev.authPort
      : EnvironmentProd.authPort;

  static String get appName => _env == 'dev'
      ? EnvironmentDev.appName
      : EnvironmentProd.appName;

  static String get apiBaseUrl => _env == 'dev'
      ? EnvironmentDev.apiBaseUrl
      : EnvironmentProd.apiBaseUrl;

  static bool get showDebugBanner => _env == 'dev'
      ? EnvironmentDev.showDebugBanner
      : EnvironmentProd.showDebugBanner;

  static String get themeColorHex => _env == 'dev'
      ? EnvironmentDev.themeColorHex
      : EnvironmentProd.themeColorHex;
}
