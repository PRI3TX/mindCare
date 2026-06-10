import 'package:flutter/material.dart';
import '../services/rutina_service.dart';
import '../services/tratamiento_service.dart';

class DashboardProvider with ChangeNotifier {
  final RutinaService _rutinaService = RutinaService();
  final TratamientoService _tratamientoService = TratamientoService();

  int totalRutinas = 0;
  int rutinasCompletadas = 0;
  int totalTratamientos = 0;
  int tratamientosCompletados = 0;

  String get consejo => "¡Un paso a la vez! Lo importante es mantener la constancia y cuidar de ti.";

  double get progresoRutinas => totalRutinas == 0 ? 0.0 : rutinasCompletadas / totalRutinas;
  double get progresoTratamientos => totalTratamientos == 0 ? 0.0 : tratamientosCompletados / totalTratamientos;

  Future<void> cargarDashboard(int usuarioId) async {
    try {
      final rutinas = await _rutinaService.obtenerRutinasPorUsuario(usuarioId);
      final tratamientos = await _tratamientoService.obtenerTratamientosPorUsuario(usuarioId);

      totalRutinas = rutinas.length;
      rutinasCompletadas = rutinas.where((r) => r.completado).length;

      totalTratamientos = tratamientos.length;
      tratamientosCompletados = tratamientos.where((t) => t.completado).length;

      notifyListeners();
    } catch (e) {
      debugPrint("Error cargando Dashboard: \$e");
    }
  }
}