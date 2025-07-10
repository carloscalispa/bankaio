import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:bankaio/data/repositories/auth_repository_impl.dart';
import 'package:bankaio/domain/repositories/auth_repository.dart';
import 'package:bankaio/domain/usecases/login_usecase.dart';
import 'package:bankaio/domain/usecases/password_reset_usecase.dart';
import 'package:bankaio/domain/usecases/logout_usecase.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final passwordResetUseCaseProvider = Provider<PasswordResetUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return PasswordResetUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final loginProvider = StateNotifierProvider.autoDispose<AuthNotifier, LoginState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final passwordResetUseCase = ref.watch(passwordResetUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  return AuthNotifier(loginUseCase, passwordResetUseCase, logoutUseCase);
});

