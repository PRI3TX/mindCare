class Usuario {
  final int? id;
  final String nombre;
  final String correo;
  final String contrasena;

  Usuario({
    this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      contrasena: map['contrasena'] ?? '',
    );
  }
}