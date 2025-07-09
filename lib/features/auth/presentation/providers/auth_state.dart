abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? message;
  const LoginSuccess({this.message});
}

class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);
}
