// 📁 lib/domain/usecases/logout_usecase.dart

import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  Future<void> call() async {
    await _authRepository.logout();
  }
}
