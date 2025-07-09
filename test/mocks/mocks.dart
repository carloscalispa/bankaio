import 'package:mocktail/mocktail.dart';
import 'package:bankaio/domain/usecases/login_usecase.dart';
import 'package:bankaio/domain/usecases/password_reset_usecase.dart';
import 'package:bankaio/features/auth/presentation/providers/auth_notifier.dart';
import 'package:bankaio/features/auth/presentation/providers/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockPasswordResetUseCase extends Mock implements PasswordResetUseCase {}

class MockAuthNotifier extends Mock implements AuthNotifier {}

class FakeLoginState extends Fake implements LoginState {}

void registerFallbacks() {
  registerFallbackValue(FakeLoginState());
}
