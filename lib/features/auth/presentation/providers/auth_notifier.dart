//lib/features/auth/presentation/providers/auth_notifier.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bankaio/core/errors/firebase_auth_error_mapper.dart';
import 'package:bankaio/domain/usecases/login_usecase.dart';
import 'package:bankaio/domain/usecases/password_reset_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final PasswordResetUseCase _passwordResetUseCase;

  AuthNotifier(this._loginUseCase, this._passwordResetUseCase)
      : super(LoginInitial());

  Future<void> login(String email, String password) async {
    state = LoginLoading();
    try {
      final user = await _loginUseCase(email, password);
      if (user != null) {
        state = const LoginSuccess();
      } else {
        state = const LoginError('Credenciales incorrectas');
      }
    } catch (e) {
      final message = mapFirebaseAuthError((e as dynamic).code ?? 'unknown');
      state = LoginError(message);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = LoginLoading();
    try {
      await _passwordResetUseCase(email);
      state = const LoginSuccess(
        message: 'Correo enviado para restablecer contraseña',
      );
    } catch (e) {
      final message = mapFirebaseAuthError((e as dynamic).code ?? 'unknown');
      state = LoginError(message);
    }
  }
}
