import 'package:flutter/material.dart';
import '../models/rutina.dart';
import '../services/rutina_service.dart';

class RutinaProvider with ChangeNotifier {
  final RutinaService _rutinaService = RutinaService();
  final int? usuarioIdActual;
  List<Rutina> _rutinas = [];

  RutinaProvider({required this.usuarioIdActual}) {
    if (usuarioIdActual != null && usuarioIdActual! > 0) {
      cargarRutinas();
    }
  }

  List<Rutina> get rutinas => _rutinas;

  Future<void> cargarRutinas() async {
    if (usuarioIdActual == null || usuarioIdActual! <= 0) return;
    _rutinas = await _rutinaService.obtenerRutinasPorUsuario(usuarioIdActual!);
    notifyListeners();
  }

  // 🛠️ CORREGIDO: Ahora acepta el String directo como lo tienes en tu pantalla, 
  // eliminando el error "'Rutina' isn't a function"
  Future<void> agregarRutina(String titulo) async {
    if (usuarioIdActual == null || usuarioIdActual! <= 0) return;
    
    final nuevaRutina = Rutina(
      usuarioId: usuarioIdActual!,
      titulo: titulo,
      fecha: DateTime.now().toString().substring(0, 10),
      completado: false,
    );
    
    await _rutinaService.insertarRutina(nuevaRutina);
    await cargarRutinas();
  }

  Future<void> actualizarRutina(Rutina rutina) async {
    await _rutinaService.actualizarRutina(rutina);
    await cargarRutinas();
  }

  Future<void> toggleRutina(Rutina rutina) async {
    final modificada = rutina.copyWith(completado: !rutina.completado);
    await _rutinaService.actualizarRutina(modificada);
    await cargarRutinas();
  }

  // 🛠️ CORREGIDO: Ajustado a un solo parámetro posicional para corregir tu segunda captura
  Future<void> eliminarRutina(int id) async {
    await _rutinaService.eliminarRutina(id);
    await cargarRutinas();
  }
}