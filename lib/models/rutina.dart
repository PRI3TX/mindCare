class Rutina {
  final int? id;
  final int usuarioId;
  final String titulo;
  final String fecha;
  final bool completado;

  Rutina({
    this.id,
    required this.usuarioId,
    required this.titulo,
    required this.fecha,
    this.completado = false,
  });

  Rutina copyWith({
    int? id,
    int? usuarioId,
    String? titulo,
    String? fecha,
    bool? completado,
  }) {
    return Rutina(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      titulo: titulo ?? this.titulo,
      fecha: fecha ?? this.fecha,
      completado: completado ?? this.completado,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'usuarioId': usuarioId,
      'titulo': titulo,
      'fecha': fecha,
      'completado': completado ? 1 : 0,
    };
  }

  factory Rutina.fromMap(Map<String, dynamic> map) {
    return Rutina(
      id: map['id'],
      usuarioId: map['usuarioId'] ?? map['usuario_id'] ?? 0,
      titulo: map['titulo'] ?? '',
      fecha: map['fecha'] ?? '',
      completado: map['completado'] == 1,
    );
  }
}