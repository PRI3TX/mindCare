class Rutina {
  final int? id;
  final int usuarioId; // 👈 Enlace relacional
  String titulo;
  String fecha;
  bool completado;

  Rutina({
    this.id,
    required this.usuarioId,
    required this.titulo,
    required this.fecha,
    this.completado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'titulo': titulo,
      'fecha': fecha,
      'completado': completado ? 1 : 0,
    };
  }

  factory Rutina.fromMap(Map<String, dynamic> map) {
    return Rutina(
      id: map['id'],
      usuarioId: map['usuario_id'],
      titulo: map['titulo'],
      fecha: map['fecha'],
      completado: map['completado'] == 1,
    );
  }
}