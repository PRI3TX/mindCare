import '../models/rutina.dart';
import 'database_service.dart';

class RutinaService {
  // Redirecciona al buscador filtrado por usuario
  Future<List<Rutina>> obtenerRutinasPorUsuario(int usuarioId) async {
    final listaMap = await DatabaseService.instance.obtenerRutinasPorUsuario(usuarioId);
    return listaMap.map((map) => Rutina.fromMap(map)).toList();
  }

  Future<void> insertarRutina(Rutina rutina) async {
    await DatabaseService.instance.insertarRutina(rutina);
  }

  Future<void> actualizarRutina(Rutina rutina) async {
    await DatabaseService.instance.actualizarRutina(rutina);
  }

  Future<void> eliminarRutina(int id) async {
    await DatabaseService.instance.eliminarRutina(id);
  }
}