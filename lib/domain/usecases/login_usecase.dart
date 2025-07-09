import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para iniciar sesión. Devuelve un [UserEntity] si el login es exitoso.
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Intenta hacer login. Si falla por usuario no encontrado, crea uno nuevo automáticamente.
  Future<UserEntity?> call(String email, String password) async {
    try {
      final user = await _repository.login(email, password);
      return user;
    } catch (e) {
      // Si no existe el usuario, intentamos crearlo
      if ((e as dynamic).code == 'user-not-found') {
        final newUser = await _repository.register(email, password);
        return newUser;
      } else {
        rethrow; // Otros errores los lanzamos
      }
    }
  }
}
