import 'package:flutter/material.dart';
import '../models/tratamiento.dart';
import '../services/tratamiento_service.dart';

class TratamientoProvider with ChangeNotifier {
  final TratamientoService _service = TratamientoService();
  final int? usuarioIdActual;
  List<Tratamiento> _tratamientos = [];

  TratamientoProvider({required this.usuarioIdActual}) {
    if (usuarioIdActual != null && usuarioIdActual! > 0) {
      cargarTratamientos();
    }
  }

  List<Tratamiento> get tratamientos => _tratamientos;

  Future<void> cargarTratamientos() async {
    if (usuarioIdActual == null || usuarioIdActual! <= 0) return;
    _tratamientos = await _service.obtenerTratamientosPorUsuario(usuarioIdActual!);
    notifyListeners();
  }

  // 🛠️ UNIFICADO: Recibe los campos limpios de texto directamente desde la UI
  Future<void> agregarTratamiento(String nombre, String descripcion) async {
    if (usuarioIdActual == null || usuarioIdActual! <= 0) return;

    final nuevoTratamiento = Tratamiento(
      usuarioId: usuarioIdActual!,
      nombre: nombre,
      descripcion: descripcion,
      fecha: DateTime.now().toString().substring(0, 10),
      completado: false,
    );

    await _service.insertarTratamiento(nuevoTratamiento);
    await cargarTratamientos();
  }

  Future<void> actualizarTratamiento(Tratamiento tratamiento) async {
    await _service.actualizarTratamiento(tratamiento);
    await cargarTratamientos();
  }

  Future<void> toggleTratamiento(Tratamiento tratamiento) async {
    final modificada = tratamiento.copyWith(completado: !tratamiento.completado);
    await _service.actualizarTratamiento(modificada);
    await cargarTratamientos();
  }

  // 🛠️ UNIFICADO: Un solo parámetro posicional para evitar errores de argumentos cruzados
  Future<void> eliminarTratamiento(int id) async {
    await _service.eliminarTratamiento(id);
    await cargarTratamientos();
  }
}