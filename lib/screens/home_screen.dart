import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';

import 'rutinas_screen.dart';
import 'tratamientos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<DashboardProvider>(
        context,
        listen: false,
      ).cargarDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {

    final dashboard =
        Provider.of<DashboardProvider>(
      context,
    );

    double progresoRutinas =
        dashboard.totalRutinas == 0
            ? 0
            : dashboard.rutinasCompletadas /
                dashboard.totalRutinas;

    double progresoTratamientos =
        dashboard.totalTratamientos == 0
            ? 0
            : dashboard
                    .tratamientosCompletados /
                dashboard.totalTratamientos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🧠 MindTrack"),
      ),

      body: RefreshIndicator(
        onRefresh: () =>
            dashboard.cargarDashboard(),
        child: ListView(
          padding:
              const EdgeInsets.all(16),
          children: [

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: const Column(
                children: [
                  Text(
                    "Bienvenido",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
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
                padding:
                    const EdgeInsets.all(
                        16),
                child: Column(
                  children: [

                    const Text(
                      "📋 Rutinas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    LinearProgressIndicator(
                      value:
                          progresoRutinas,
                    ),

                    const SizedBox(
                        height: 10),

                    Text(
                      "${dashboard.rutinasCompletadas} de ${dashboard.totalRutinas} completadas",
                    ),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                        16),
                child: Column(
                  children: [

                    const Text(
                      "💊 Tratamientos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    LinearProgressIndicator(
                      value:
                          progresoTratamientos,
                    ),

                    const SizedBox(
                        height: 10),

                    Text(
                      "${dashboard.tratamientosCompletados} de ${dashboard.totalTratamientos} completados",
                    ),
                  ],
                ),
              ),
            ),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                        16),
                child: Column(
                  children: [

                    const Text(
                      "💬 Consejo del día",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    Text(
                      dashboard.consejo,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(
                  Icons.check_circle),
              label:
                  const Text("Rutinas"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const RutinasScreen(),
                  ),
                );

                dashboard
                    .cargarDashboard();
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              icon: const Icon(
                  Icons.medication),
              label: const Text(
                  "Tratamientos"),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TratamientosScreen(),
                  ),
                );

                dashboard
                    .cargarDashboard();
              },
            ),
          ],
        ),
      ),
    );
  }
}