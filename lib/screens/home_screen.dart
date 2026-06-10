import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import 'rutinas_screen.dart';
import 'tratamientos_screen.dart';

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
      final userId = Provider.of<AuthProvider>(context, listen: false).usuarioIdActual;
      Provider.of<DashboardProvider>(context, listen: false).cargarDashboard(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final dashboard = Provider.of<DashboardProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("MindTrack Dashboard"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => auth.logout())],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await dashboard.cargarDashboard(auth.usuarioIdActual),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("¡Hola, ${auth.nombreUsuario}!", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 10),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Consejo del Día", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(dashboard.consejo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const Text("Tu Progreso Actual", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildProgressCard(
                title: "Rutinas Diarias",
                subtitle: "${dashboard.rutinasCompletadas} de ${dashboard.totalRutinas} completadas",
                value: dashboard.progresoRutinas,
                color: Colors.blue,
                icon: Icons.calendar_today,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RutinasScreen())).then((_) {
                  dashboard.cargarDashboard(auth.usuarioIdActual);
                }),
              ),
              const SizedBox(height: 15),
              _buildProgressCard(
                title: "Tratamientos / Hábitos",
                subtitle: "${dashboard.tratamientosCompletados} de ${dashboard.totalTratamientos} completados",
                value: dashboard.progresoTratamientos,
                color: Colors.orange,
                icon: Icons.medical_services,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TratamientosScreen())).then((_) {
                  // 🛠️ CORREGIDO: Removido el '.authProvider' redundante que causaba crash
                  dashboard.cargarDashboard(auth.usuarioIdActual);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard({required String title, required String subtitle, required double value, required Color color, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            LinearProgressIndicator(value: value, backgroundColor: Colors.grey.shade200, color: color),
            const SizedBox(height: 5),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}