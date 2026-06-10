import '../models/tratamiento.dart';
import 'database_service.dart';

class TratamientoService {
  // OBTENER TRATAMIENTOS POR USUARIO
  Future<List<Tratamiento>> obtenerTratamientosPorUsuario(int usuarioId) async {
    final db = await DatabaseService.instance.database;
    
    try {
      // Intentamos buscar por 'usuarioId' (camelCase)
      final List<Map<String, dynamic>> maps = await db.query(
        'tratamientos',
        where: 'usuarioId = ?',
        whereArgs: [usuarioId],
      );
      return List.generate(maps.length, (i) => Tratamiento.fromMap(maps[i]));
    } catch (_) {
      // Fallback: Si la columna física se creó como 'usuario_id', busca por aquí
      final List<Map<String, dynamic>> maps = await db.query(
        'tratamientos',
        where: 'usuario_id = ?',
        whereArgs: [usuarioId],
      );
      return List.generate(maps.length, (i) => Tratamiento.fromMap(maps[i]));
    }
  }

  // INSERTAR TRATAMIENTO
  Future<int> insertarTratamiento(Tratamiento tratamiento) async {
    final db = await DatabaseService.instance.database;
    final mapa = tratamiento.toMap();
    
    try {
      return await db.insert('tratamientos', mapa);
    } catch (e) {
      // Si la tabla espera 'usuario_id' pero enviamos 'usuarioId', lo corregimos en caliente
      if (mapa.containsKey('usuarioId')) {
        mapa['usuario_id'] = mapa.remove('usuarioId');
      }
      return await db.insert('tratamientos', mapa);
    }
  }

  // ACTUALIZAR TRATAMIENTO
  Future<int> actualizarTratamiento(Tratamiento tratamiento) async {
    final db = await DatabaseService.instance.database;
    final mapa = tratamiento.toMap();
    
    try {
      return await db.update(
        'tratamientos',
        mapa,
        where: 'id = ?',
        whereArgs: [tratamiento.id],
      );
    } catch (e) {
      if (mapa.containsKey('usuarioId')) {
        mapa['usuario_id'] = mapa.remove('usuarioId');
      }
      return await db.update(
        'tratamientos',
        mapa,
        where: 'id = ?',
        whereArgs: [tratamiento.id],
      );
    }
  }

  // ELIMINAR TRATAMIENTO
  // 🛠️ CORREGIDO: Ahora recibe únicamente el ID del tratamiento (1 solo argumento posicional)
  // para que haga match perfecto con la llamada del TratamientoProvider.
  Future<int> eliminarTratamiento(int id) async {
    final db = await DatabaseService.instance.database;
    return await db.delete(
      'tratamientos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}