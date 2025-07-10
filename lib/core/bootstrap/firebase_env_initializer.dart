import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:bankaio/firebase_options.dart';
import 'package:flutter/material.dart';
import '../config/environment.dart';
import 'dart:io' show Platform;

Future<void> initializeFirebaseWithEnv({required bool useEmulators}) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (useEmulators) {
    // Para Android Emulator, usar 10.0.2.2 en lugar de localhost
    String authHost = Environment.authHost;
    String firestoreHost = Environment.firestoreHost;
    
    if (Platform.isAndroid) {
      // Mapear localhost a 10.0.2.2 para Android Emulator
      authHost = authHost.replaceAll('localhost', '10.0.2.2');
      firestoreHost = firestoreHost.replaceAll('localhost', '10.0.2.2');
      debugPrint('Mapping Auth Emulator host "${Environment.authHost}" to "$authHost".');
      debugPrint('Mapping Firestore Emulator host "${Environment.firestoreHost}" to "$firestoreHost".');
    }
    
    try {
      await FirebaseAuth.instance.useAuthEmulator(
        authHost.replaceAll(':${Environment.authPort}', ''), // Solo el host
        Environment.authPort,
      );
      debugPrint('✅ Auth Emulator configurado en $authHost:${Environment.authPort}');
    } catch (e) {
      debugPrint('⚠️ Error configurando Auth Emulator: $e');
    }

    try {
      final firestoreHostOnly = firestoreHost.split(':')[0];
      final firestorePort = int.parse(firestoreHost.split(':')[1]);
      
      FirebaseFirestore.instance.useFirestoreEmulator(firestoreHostOnly, firestorePort);
      debugPrint('✅ Firestore Emulator configurado en $firestoreHost');
    } catch (e) {
      debugPrint('⚠️ Error configurando Firestore Emulator: $e');
    }

    try {
      final functionsHost = authHost.replaceAll(':${Environment.authPort}', '');
      FirebaseFunctions.instance.useFunctionsEmulator(functionsHost, 5001);
      debugPrint('✅ Functions Emulator configurado en $functionsHost:5001');
    } catch (e) {
      debugPrint('⚠️ Error configurando Functions Emulator: $e');
    }
  }
}