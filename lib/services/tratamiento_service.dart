import '../models/tratamiento.dart';
import 'database_service.dart';

class TratamientoService {

  // 📋 Obtener tratamientos filtrados por el usuario activo
  Future<List<Tratamiento>> obtenerTratamientosPorUsuario(int usuarioId) async {
    final db = await DatabaseService.instance.database;

    final maps = await db.query(
      'tratamientos',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'id DESC',
    );

    return List.generate(
      maps.length,
      (i) => Tratamiento.fromMap(maps[i]),
    );
  }

  Future<int> insertarTratamiento(Tratamiento tratamiento) async {
    final db = await DatabaseService.instance.database;
    return await db.insert(
      'tratamientos',
      tratamiento.toMap(),
    );
  }

  Future<int> actualizarTratamiento(Tratamiento tratamiento) async {
    final db = await DatabaseService.instance.database;
    return await db.update(
      'tratamientos',
      tratamiento.toMap(),
      where: 'id = ?',
      whereArgs: [tratamiento.id],
    );
  }

  Future<int> eliminarTratamiento(int id) async {
    final db = await DatabaseService.instance.database;
    return await db.delete(
      'tratamientos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}