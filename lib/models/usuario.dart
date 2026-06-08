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

  // Convierte el objeto a un Map para insertarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
    };
  }

  // Crea un Usuario a partir de un registro de la base de datos
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      correo: map['correo'],
      contrasena: map['contrasena'],
    );
  }
}