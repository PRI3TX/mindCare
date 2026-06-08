import 'package:flutter/material.dart';
import '../models/tratamiento.dart';
import '../services/tratamiento_service.dart';

class TratamientoProvider with ChangeNotifier {
  final TratamientoService _service = TratamientoService();
  List<Tratamiento> _tratamientos = [];

  List<Tratamiento> get tratamientos => _tratamientos;

  Future<void> cargarTratamientos(int usuarioId) async {
    _tratamientos = await _service.obtenerTratamientosPorUsuario(usuarioId);
    notifyListeners();
  }

  Future<void> agregarTratamiento(Tratamiento tratamiento) async {
    await _service.insertarTratamiento(tratamiento);
    await cargarTratamientos(tratamiento.usuarioId);
  }

  Future<void> actualizarTratamiento(Tratamiento tratamiento) async {
    await _service.actualizarTratamiento(tratamiento);
    await cargarTratamientos(tratamiento.usuarioId);
  }

  Future<void> toggleTratamiento(Tratamiento tratamiento) async {
    final modificado = tratamiento.copyWith(completado: !tratamiento.completado);
    await actualizarTratamiento(modificado);
  }

  Future<void> eliminarTratamiento(int id, int usuarioId) async {
    await _service.eliminarTratamiento(id);
    await cargarTratamientos(usuarioId);
  }
}