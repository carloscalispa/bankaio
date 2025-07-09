// 📁 lib/core/errors/firebase_auth_error_mapper.dart

String mapFirebaseAuthError(String code) {
  switch (code) {
    case 'invalid-email':
      return 'El correo electrónico no es válido.';
    case 'user-disabled':
      return 'Este usuario ha sido deshabilitado.';
    case 'user-not-found':
      return 'No existe una cuenta con este correo.';
    case 'wrong-password':
      return 'La contraseña es incorrecta.';
    case 'email-already-in-use':
      return 'Este correo ya está registrado.';
    case 'operation-not-allowed':
      return 'Esta operación no está permitida.';
    case 'weak-password':
      return 'La contraseña es muy débil.';
    case 'too-many-requests':
      return 'Demasiados intentos. Intenta de nuevo más tarde.';
    case 'network-request-failed':
      return 'Sin conexión a internet.';
    case 'invalid-credential':
      return 'Las credenciales no son válidas.';
    case 'missing-email':
      return 'Debes ingresar un correo electrónico.';
    case 'missing-password':
      return 'Debes ingresar una contraseña.';
    case 'internal-error':
      return 'Ocurrió un error interno. Intenta más tarde.';
    case 'unknown':
    default:
      return 'Error desconocido. Intenta de nuevo.';
  }
}
