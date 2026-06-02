import 'package:flutter/material.dart';

import '../services/rutina_service.dart';
import '../services/tratamiento_service.dart';

class DashboardProvider with ChangeNotifier {
  int totalRutinas = 0;
  int rutinasCompletadas = 0;

  int totalTratamientos = 0;
  int tratamientosCompletados = 0;

  String consejo = "";

  final RutinaService _rutinaService = RutinaService();
  final TratamientoService _tratamientoService =
      TratamientoService();

  final List<String> consejos = [
    "Un pequeño avance sigue siendo un avance.",
    "Hoy no necesitas ser perfecto, solo avanzar.",
    "Haz lo que puedas con lo que tienes.",
    "Cada tarea completada cuenta.",
    "Descansar también es productividad.",
    "La constancia supera la perfección.",
    "Un paso a la vez.",
    "Lo importante es no detenerse.",
  ];

  Future<void> cargarDashboard() async {
    final rutinas =
        await _rutinaService.obtenerRutinas();

    final tratamientos =
        await _tratamientoService
            .obtenerTratamientos();

    totalRutinas = rutinas.length;

    rutinasCompletadas =
        rutinas.where((r) => r.completado).length;

    totalTratamientos =
        tratamientos.length;

    tratamientosCompletados =
        tratamientos
            .where((t) => t.completado)
            .length;

    consejo = consejos[
        DateTime.now().day %
            consejos.length];

    notifyListeners();
  }
}