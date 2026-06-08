import 'package:flutter/material.dart';
import '../models/rutina.dart';
import '../services/database_service.dart';

class RutinaProvider with ChangeNotifier {
  List<Rutina> _rutinas = [];
  List<Rutina> get rutinas => _rutinas;

  // 🔍 Cargar Rutinas exclusivas
  Future<void> cargarRutinas(int usuarioId) async {
    final listaMap = await DatabaseService.instance.obtenerRutinasPorUsuario(usuarioId);
    _rutinas = listaMap.map((map) => Rutina.fromMap(map)).toList();
    print("Rutinas cargadas para el usuario ID $usuarioId: ${_rutinas.length}");
    notifyListeners();
  }

  Future<void> agregarRutina(Rutina rutina) async {
    await DatabaseService.instance.insertarRutina(rutina);
    await cargarRutinas(rutina.usuarioId);
  }

  Future<void> actualizarRutina(Rutina rutina) async {
    await DatabaseService.instance.actualizarRutina(rutina);
    await cargarRutinas(rutina.usuarioId);
  }

  Future<void> toggleRutina(Rutina rutina) async {
    rutina.completado = !rutina.completado;
    await DatabaseService.instance.actualizarRutina(rutina);
    await cargarRutinas(rutina.usuarioId);
  }

  Future<void> eliminarRutina(int id, int usuarioId) async {
    await DatabaseService.instance.eliminarRutina(id);
    await cargarRutinas(usuarioId);
  }
}