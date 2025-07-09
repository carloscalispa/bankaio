import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBLpF-S0iSpS5y2_jFktn5IXzMV-Ry2814',
    appId: '1:273018994023:web:fd20a8a6fcd209ef1d03c2',
    messagingSenderId: '273018994023',
    projectId: 'bankaio-766e3',
    authDomain: 'bankaio-766e3.firebaseapp.com',
    storageBucket: 'bankaio-766e3.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg-2VQCpXz7bKWZehTwzwW3NBqRuO6vl4',
    appId: '1:273018994023:android:6e7ea0afc0a359311d03c2',
    messagingSenderId: '273018994023',
    projectId: 'bankaio-766e3',
    storageBucket: 'bankaio-766e3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAt6fnUcHGGg8tPEOxweEarYpCMVwv0ADw',
    appId: '1:273018994023:ios:fc28137380723ebc1d03c2',
    messagingSenderId: '273018994023',
    projectId: 'bankaio-766e3',
    storageBucket: 'bankaio-766e3.firebasestorage.app',
    iosBundleId: 'com.calispa.bankaio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAt6fnUcHGGg8tPEOxweEarYpCMVwv0ADw',
    appId: '1:273018994023:ios:fc28137380723ebc1d03c2',
    messagingSenderId: '273018994023',
    projectId: 'bankaio-766e3',
    storageBucket: 'bankaio-766e3.firebasestorage.app',
    iosBundleId: 'com.calispa.bankaio',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBLpF-S0iSpS5y2_jFktn5IXzMV-Ry2814',
    appId: '1:273018994023:web:055a9c4987d052f41d03c2',
    messagingSenderId: '273018994023',
    projectId: 'bankaio-766e3',
    authDomain: 'bankaio-766e3.firebaseapp.com',
    storageBucket: 'bankaio-766e3.firebasestorage.app',
  );
}
