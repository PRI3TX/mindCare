import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/usuario.dart';

class AuthProvider with ChangeNotifier {
  int _usuarioIdActual = -1;
  String _nombreUsuario = "";
  bool _isLoggedIn = false;

  int get usuarioIdActual => _usuarioIdActual;
  String get nombreUsuario => _nombreUsuario;
  bool get isLoggedIn => _isLoggedIn;

  // 🔐 MÉTODO DE LOGIN CON HARDCODE TEMPORAL PARA PRUEBAS
  Future<bool> login(String correo, String contrasena) async {
    try {
      final emailLimpio = correo.trim().toLowerCase();
      final passwordLimpia = contrasena.trim();

      // 🧪 TRUCO TEMPORAL: Bypass directo sin pasar por SQLite
      if (emailLimpio == 'admin@test.com' && passwordLimpia == '123456') {
        _usuarioIdActual = 1;
        _nombreUsuario = "Usuario de Prueba";
        _isLoggedIn = true;
        notifyListeners();
        return true; // Acceso garantizado para testear la app
      }

      // LÓGICA REAL CON LA BASE DE DATOS
      final usuarioMap = await DatabaseService.instance.buscarUsuarioPorCorreo(emailLimpio);

      if (usuarioMap != null) {
        final usuario = Usuario.fromMap(usuarioMap);

        if (usuario.contrasena.trim() == passwordLimpia) {
          _usuarioIdActual = usuario.id!;
          _nombreUsuario = usuario.nombre;
          _isLoggedIn = true;
          notifyListeners();
          return true; // Login correcto por BD
        }
      }
      return false; // Credenciales inválidas
    } catch (e) {
      debugPrint("Error en AuthProvider (Login): $e");
      return false;
    }
  }

  // MÉTODO DE REGISTRO
  Future<bool> registrarUsuario(String nombre, String correo, String contrasena) async {
    try {
      final nuevoUsuario = Usuario(
        nombre: nombre.trim(),
        correo: correo.trim().toLowerCase(),
        contrasena: contrasena.trim(),
      );

      final id = await DatabaseService.instance.insertarUsuario(nuevoUsuario.toMap());
      return id > 0;
    } catch (e) {
      debugPrint("Error en AuthProvider (Registro): $e");
      return false;
    }
  }

  // CIERRE DE SESIÓN
  void logout() {
    _usuarioIdActual = -1;
    _nombreUsuario = "";
    _isLoggedIn = false;
    notifyListeners();
  }
}