class Rutina {
  int? id;
  String titulo;
  bool completado;
  String fecha;

  Rutina({
    this.id,
    required this.titulo,
    this.completado = false,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'completado': completado ? 1 : 0,
      'fecha': fecha,
    };
  }

  factory Rutina.fromMap(Map<String, dynamic> map) {
    return Rutina(
      id: map['id'],
      titulo: map['titulo'],
      completado: map['completado'] == 1,
      fecha: map['fecha'],
    );
  }
}