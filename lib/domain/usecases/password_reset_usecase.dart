import '../repositories/auth_repository.dart';

class PasswordResetUseCase {
  final AuthRepository repository;

  PasswordResetUseCase(this.repository);

  Future<void> call(String email) async {
    await repository.sendPasswordResetEmail(email);
  }
}

