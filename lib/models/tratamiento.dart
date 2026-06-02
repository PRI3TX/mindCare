class Tratamiento {
  int? id;
  String nombre;
  String descripcion;
  bool completado;
  String fecha;

  Tratamiento({
    this.id,
    required this.nombre,
    required this.descripcion,
    this.completado = false,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'completado': completado ? 1 : 0,
      'fecha': fecha,
    };
  }

  factory Tratamiento.fromMap(
    Map<String, dynamic> map,
  ) {
    return Tratamiento(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      completado: map['completado'] == 1,
      fecha: map['fecha'],
    );
  }
}