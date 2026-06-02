import 'package:flutter/material.dart';
import '../models/rutina.dart';
import '../services/rutina_service.dart';

class RutinaProvider with ChangeNotifier {

  List<Rutina> _rutinas = [];

  final RutinaService _service =
      RutinaService();

  List<Rutina> get rutinas => _rutinas;

  Future<void> cargarRutinas() async {

    _rutinas =
        await _service.obtenerRutinas();

    print(
      "Rutinas cargadas: ${_rutinas.length}",
    );

    notifyListeners();
  }

  Future<void> agregarRutina(
      Rutina rutina) async {

    await _service.insertarRutina(
      rutina,
    );

    await cargarRutinas();
  }

  Future<void> actualizarRutina(
      Rutina rutina) async {

    await _service.actualizarRutina(
      rutina,
    );

    await cargarRutinas();
  }

  Future<void> toggleRutina(
      Rutina rutina) async {

    rutina.completado =
        !rutina.completado;

    await _service.actualizarRutina(
      rutina,
    );

    await cargarRutinas();
  }

  Future<void> eliminarRutina(
      int id) async {

    await _service.eliminarRutina(id);

    await cargarRutinas();
  }
}