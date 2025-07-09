import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart'; // ✅ CORREGIDO

import 'package:bankaio/firebase_options.dart'; // Asegúrate de tener este archivo generado

Future<void> initializeFirebaseApp({required bool useEmulators}) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (useEmulators) {
    const localHost = 'localhost';

    // 🔐 Auth Emulator
    try {
      await FirebaseAuth.instance.useAuthEmulator(localHost, 9099);
    } catch (_) {}

    // 🔥 Firestore Emulator
    FirebaseFirestore.instance.useFirestoreEmulator(localHost, 8080);

    // ⚙️ Functions Emulator
    FirebaseFunctions.instance.useFunctionsEmulator(localHost, 5001); // ✅ Funciona con cloud_functions
  }
}
