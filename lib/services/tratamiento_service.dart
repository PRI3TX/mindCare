import '../models/tratamiento.dart';
import 'database_service.dart';

class TratamientoService {

  Future<List<Tratamiento>>
      obtenerTratamientos() async {

    final db = await DatabaseService.database;

    final maps = await db.query(
      'tratamientos',
      orderBy: 'id DESC',
    );

    return List.generate(
      maps.length,
      (i) => Tratamiento.fromMap(maps[i]),
    );
  }

  Future<int> insertarTratamiento(
      Tratamiento tratamiento) async {

    final db = await DatabaseService.database;

    return await db.insert(
      'tratamientos',
      tratamiento.toMap(),
    );
  }

  Future<int> actualizarTratamiento(
      Tratamiento tratamiento) async {

    final db = await DatabaseService.database;

    return await db.update(
      'tratamientos',
      tratamiento.toMap(),
      where: 'id=?',
      whereArgs: [tratamiento.id],
    );
  }

  Future<int> eliminarTratamiento(
      int id) async {

    final db = await DatabaseService.database;

    return await db.delete(
      'tratamientos',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}