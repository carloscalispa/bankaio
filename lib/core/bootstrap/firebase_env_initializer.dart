import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankaio/firebase_options.dart';
import '../config/environment.dart';

Future<void> initializeFirebaseWithEnv({required bool useEmulators}) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (useEmulators) {
    await FirebaseAuth.instance.useAuthEmulator(
      Environment.authHost,
      Environment.authPort,
    );

    FirebaseFirestore.instance.settings = Settings(
      host: Environment.firestoreHost,
      sslEnabled: false,
      persistenceEnabled: false,
    );
  }
}