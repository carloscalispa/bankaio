// 📁 lib/data/repositories/auth_repository_impl.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<UserEntity?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        return UserEntity(uid: user.uid, email: user.email ?? '');
      }

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Si el usuario no existe, se registra automáticamente
        return register(email, password);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<UserEntity?> register(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      return UserEntity(uid: user.uid, email: user.email ?? '');
    }

    return null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
