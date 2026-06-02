import '../models/rutina.dart';
import 'database_service.dart';

class RutinaService {

  Future<List<Rutina>> obtenerRutinas() async {
    final db = await DatabaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query(
      'rutinas',
      orderBy: 'id DESC',
    );

    print("Rutinas en BD: ${maps.length}");

    return List.generate(
      maps.length,
      (i) => Rutina.fromMap(maps[i]),
    );
  }

  Future<int> insertarRutina(
      Rutina rutina) async {

    final db = await DatabaseService.database;

    int id = await db.insert(
      'rutinas',
      rutina.toMap(),
    );

    print("Rutina guardada con ID: $id");

    return id;
  }

  Future<int> actualizarRutina(
      Rutina rutina) async {

    final db = await DatabaseService.database;

    return await db.update(
      'rutinas',
      rutina.toMap(),
      where: 'id = ?',
      whereArgs: [rutina.id],
    );
  }

  Future<int> eliminarRutina(
      int id) async {

    final db = await DatabaseService.database;

    return await db.delete(
      'rutinas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}