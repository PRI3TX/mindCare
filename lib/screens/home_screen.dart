import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart'; 

import 'rutinas_screen.dart';
import 'tratamientos_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // 1. Obtenemos el ID del usuario logueado actualmente
      final userId = Provider.of<AuthProvider>(context, listen: false).usuarioIdActual;
      
      // 2. Cargamos el Dashboard pasando el filtro de usuario requerido
      Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).cargarDashboard(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = Provider.of<DashboardProvider>(context);
    // Extraemos el AuthProvider completo para poder leer el ID y el nombre
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.usuarioIdActual;

    double progresoRutinas = dashboard.totalRutinas == 0
        ? 0
        : dashboard.rutinasCompletadas / dashboard.totalRutinas;

    double progresoTratamientos = dashboard.totalTratamientos == 0
        ? 0
        : dashboard.tratamientosCompletados / dashboard.totalTratamientos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🧠 MindTrack"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Cerrar Sesión",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Cerrar Sesión"),
                    content: const Text("¿Estás seguro de que deseas salir de tu cuenta?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () async {
                          Navigator.pop(context); // Cierra el modal

                          // Limpia el estado y borra el flag de SharedPreferences
                          await authProvider.logout();

                          // Redirige al login limpiando el historial de navegación
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          }
                        },
                        child: const Text(
                          "Salir",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        // 📋 MODIFICADO: Agregado el userId al recargar deslizando hacia abajo
        onRefresh: () => dashboard.cargarDashboard(userId),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    "¡Hola, ${Provider.of<AuthProvider>(context).nombreUsuario.split(' ')[0]}!",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tu bienestar es importante.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "📋 Rutinas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progresoRutinas,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${dashboard.rutinasCompletadas} de ${dashboard.totalRutinas} completadas",
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "💊 Tratamientos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progresoTratamientos,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${dashboard.tratamientosCompletados} de ${dashboard.totalTratamientos} completados",
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "💬 Consejo del día",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      dashboard.consejo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text("Rutinas"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RutinasScreen(),
                  ),
                );
                // 📋 MODIFICADO: Recarga las métricas del usuario actual al regresar de las rutinas
                dashboard.cargarDashboard(userId);
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.medication),
              label: const Text("Tratamientos"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TratamientosScreen(),
                  ),
                );
                // 📋 MODIFICADO: Recarga las métricas del usuario actual al regresar de los tratamientos
                dashboard.cargarDashboard(userId);
              },
            ),
          ],
        ),
      ),
    );
  }
}