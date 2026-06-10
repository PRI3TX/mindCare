import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Cuenta"), 
        backgroundColor: Colors.teal, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nombreController, decoration: const InputDecoration(labelText: "Nombre completo")),
            const SizedBox(height: 10),
            TextField(controller: correoController, decoration: const InputDecoration(labelText: "Correo electrónico")),
            const SizedBox(height: 10),
            TextField(controller: contrasenaController, obscureText: true, decoration: const InputDecoration(labelText: "Contraseña")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final correo = correoController.text.trim();
                final contrasena = contrasenaController.text.trim();

                if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Todos los campos son obligatorios")),
                  );
                  return;
                }

                // 🛠️ CORREGIDO: Se pasan los strings independientes requeridos por el AuthProvider unificado
                final exito = await Provider.of<AuthProvider>(context, listen: false)
                    .registrarUsuario(nombre, correo, contrasena);

                if (exito && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("¡Registro Exitoso! Ya puedes iniciar sesión")),
                  );
                  Navigator.pop(context);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al registrar. Puede que el correo ya exista.")),
                  );
                }
              },
              child: const Text("Registrarse"),
            )
          ],
        ),
      ),
    );
  }
}