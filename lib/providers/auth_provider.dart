import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 👈 CORREGIDO: Import oficial de Flutter
import '../models/usuario.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  bool _estaLogueado = false;
  String _nombreUsuario = "";
  int _usuarioIdActual = 0; 

  bool get estaLogueado => _estaLogueado;
  String get nombreUsuario => _nombreUsuario;
  int get usuarioIdActual => _usuarioIdActual;

  AuthProvider() {
    verificarSesion();
  }

  Future<void> verificarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    _estaLogueado = prefs.getBool('isLoggedIn') ?? false;
    _nombreUsuario = prefs.getString('userName') ?? "";
    _usuarioIdActual = prefs.getInt('userId') ?? 0;
    notifyListeners();
  }

  Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      await DatabaseService.instance.registrarUsuario(usuario);
      return true;
    } catch (e) {
      debugPrint("Error en registro: $e");
      return false;
    }
  }

  Future<bool> login(String correo, String contrasena) async {
    try {
      final res = await DatabaseService.instance.buscarUsuarioPorCorreo(correo);
      
      if (res != null && res['contrasena'] == contrasena) {
        final prefs = await SharedPreferences.getInstance();
        
        _usuarioIdActual = res['id'];
        _nombreUsuario = res['nombre'];
        _estaLogueado = true;

        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userName', _nombreUsuario);
        await prefs.setInt('userId', _usuarioIdActual);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error en login: $e");
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _estaLogueado = false;
    _nombreUsuario = "";
    _usuarioIdActual = 0;
    notifyListeners();
  }
}