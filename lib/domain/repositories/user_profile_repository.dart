// 📁 lib/domain/repositories/user_profile_repository.dart
import '../entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<void> saveUserProfile(UserProfileEntity profile);
}
