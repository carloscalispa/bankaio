// 📁 lib/domain/entities/user_profile_entity.dart
class UserProfileEntity {
  final String uid;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String direccion;

  UserProfileEntity({
    required this.uid,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.direccion,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'direccion': direccion,
    };
  }
}