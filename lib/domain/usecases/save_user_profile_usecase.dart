// 📁 lib/domain/usecases/save_user_profile_usecase.dart
import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class SaveUserProfileUseCase {
  final UserProfileRepository repository;

  SaveUserProfileUseCase(this.repository);

  Future<void> call(UserProfileEntity profile) {
    return repository.saveUserProfile(profile);
  }
}
