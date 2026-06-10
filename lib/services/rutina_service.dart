import '../models/rutina.dart';
import 'database_service.dart';

class RutinaService {
  // OBTENER RUTINAS POR USUARIO
  Future<List<Rutina>> obtenerRutinasPorUsuario(int usuarioId) async {
    final db = await DatabaseService.instance.database;
    
    // 🔍 Probamos buscar tanto por 'usuarioId' como por 'usuario_id' por seguridad
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'rutinas',
        where: 'usuarioId = ?',
        whereArgs: [usuarioId],
      );
      return List.generate(maps.length, (i) => Rutina.fromMap(maps[i]));
    } catch (_) {
      // Si la columna en tu BD física se creó con guion bajo, este fallback salvará la app
      final List<Map<String, dynamic>> maps = await db.query(
        'rutinas',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
      );
      return List.generate(maps.length, (i) => Rutina.fromMap(maps[i]));
    }
  }

  // INSERTAR RUTINA
  Future<int> insertarRutina(Rutina rutina) async {
    final db = await DatabaseService.instance.database;
    
    // Convertimos el modelo a Mapa
    final mapa = rutina.toMap();
    
    try {
      return await db.insert('rutinas', mapa);
    } catch (e) {
      // Si la columna en la BD se llama 'usuario_id' pero el mapa lleva 'usuarioId',
      // lo corregimos dinámicamente en caliente para que SQLite no falle.
      if (mapa.containsKey('usuarioId')) {
        mapa['usuario_id'] = mapa.remove('usuarioId');
      }
      return await db.insert('rutinas', mapa);
    }
  }

  // ACTUALIZAR RUTINA
  Future<int> actualizarRutina(Rutina rutina) async {
    final db = await DatabaseService.instance.database;
    final mapa = rutina.toMap();
    
    try {
      return await db.update(
        'rutinas',
        mapa,
        where: 'id = ?',
        whereArgs: [rutina.id],
      );
    } catch (e) {
      if (mapa.containsKey('usuarioId')) {
        mapa['usuario_id'] = mapa.remove('usuarioId');
      }
      return await db.update(
        'rutinas',
        mapa,
        where: 'id = ?',
        whereArgs: [rutina.id],
      );
    }
  }

  // ELIMINAR RUTINA
  Future<int> eliminarRutina(int id) async {
    final db = await DatabaseService.instance.database;
    return await db.delete(
      'rutinas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}