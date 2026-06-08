class Tratamiento {
  final int? id;
  final int usuarioId;
  final String nombre;
  final String descripcion;
  final String fecha;
  final bool completado;

  Tratamiento({
    this.id,
    required this.usuarioId,
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    this.completado = false,
  });

  // 🛠️ CRÍTICO: Permite modificar campos de un objeto inmutable creando una copia
  Tratamiento copyWith({
    int? id,
    int? usuarioId,
    String? nombre,
    String? descripcion,
    String? fecha,
    bool? completado,
  }) {
    return Tratamiento(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      fecha: fecha ?? this.fecha,
      completado: completado ?? this.completado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'usuario_id': usuarioId,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha': fecha,
      'completado': completado ? 1 : 0,
    };
  }

  factory Tratamiento.fromMap(Map<String, dynamic> map) {
    return Tratamiento(
      id: map['id'],
      usuarioId: map['usuario_id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      fecha: map['fecha'],
      completado: map['completado'] == 1,
    );
  }
}