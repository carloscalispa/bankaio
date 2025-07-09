// 📁 lib/data/repositories/user_profile_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> saveUserProfile(UserProfileEntity profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toMap());
  }
}