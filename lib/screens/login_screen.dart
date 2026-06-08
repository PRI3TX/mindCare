import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'registro_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _passController = TextEditingController();
  bool _ocultarPass = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.psychology, size: 80, color: Colors.teal),
                const SizedBox(height: 10),
                const Text(
                  "MindTrack",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 30),
                
                // Campo Correo
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) return "Ingresa un correo válido";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Contraseña
                TextFormField(
                  controller: _passController,
                  obscureText: _ocultarPass,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_ocultarPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _ocultarPass = !_ocultarPass),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) return "Mínimo 6 caracteres";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botón Ingresar
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool exito = await authProvider.login(
                        _correoController.text.trim(),
                        _passController.text.trim(),
                      );
                      if (exito && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Credenciales incorrectas")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text("Iniciar Sesión", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                
                const SizedBox(height: 16),
                
                // Link a Registro
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistroScreen()));
                  },
                  child: const Text("¿No tienes cuenta? Regístrate aquí", style: TextStyle(color: Colors.teal)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}