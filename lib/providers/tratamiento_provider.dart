import 'package:flutter/material.dart';
import '../models/tratamiento.dart';
import '../services/tratamiento_service.dart';

class TratamientoProvider with ChangeNotifier {
  List<Tratamiento> _tratamientos = [];

  final TratamientoService _service = TratamientoService();

  List<Tratamiento> get tratamientos => _tratamientos;

  Future<void> cargarTratamientos() async {
    _tratamientos = await _service.obtenerTratamientos();
    notifyListeners();
  }

  Future<void> agregarTratamiento(
      Tratamiento tratamiento) async {
    await _service.insertarTratamiento(tratamiento);
    await cargarTratamientos();
  }

  Future<void> actualizarTratamiento(
      Tratamiento tratamiento) async {
    await _service.actualizarTratamiento(tratamiento);
    await cargarTratamientos();
  }

  Future<void> eliminarTratamiento(int id) async {
    await _service.eliminarTratamiento(id);
    await cargarTratamientos();
  }

  Future<void> toggleTratamiento(
      Tratamiento tratamiento) async {
    tratamiento.completado =
        !tratamiento.completado;

    await _service.actualizarTratamiento(
        tratamiento);

    await cargarTratamientos();
  }
}