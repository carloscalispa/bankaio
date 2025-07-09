import 'package:bankaio/data/repositories/auth_repository_impl.dart';
import 'package:bankaio/domain/usecases/reset_password_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final passwordResetProvider =
    StateNotifierProvider<PasswordResetNotifier, bool>((ref) {
  final resetPasswordUseCase =
      ResetPasswordUseCase(AuthRepositoryImpl());
  return PasswordResetNotifier(resetPasswordUseCase);
});

class PasswordResetNotifier extends StateNotifier<bool> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  PasswordResetNotifier(this._resetPasswordUseCase) : super(false);

  Future<String?> sendResetEmail(String email) async {
    try {
      state = true;
      await _resetPasswordUseCase(email);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      state = false;
    }
  }
}
