// lib/features/auth/presentation/providers/login_page_flow.dart

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_provider.dart';
import 'auth_state.dart';

class LoginPageFlow {
  final WidgetRef ref;

  LoginPageFlow(this.ref);

  bool isLoading(LoginState state) => state is LoginLoading;

  Future<void> login(String email, String password) async {
    final notifier = ref.read(loginProvider.notifier);
    await notifier.login(email, password);
  }
}
