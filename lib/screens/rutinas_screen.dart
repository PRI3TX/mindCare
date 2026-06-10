import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rutina.dart';
import '../providers/rutina_provider.dart';

class RutinasScreen extends StatefulWidget {
  const RutinasScreen({super.key});

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  final tituloController = TextEditingController();

  @override
  void dispose() {
    tituloController.dispose();
    super.dispose();
  }

  void mostrarDialogoEditar(Rutina rutina) {
    final tituloCtrl = TextEditingController(text: rutina.titulo);

    showDialog(
      context: context,
      barrierDismissible: false, // Evita cierres accidentales durante la escritura en BD
      builder: (dialogContext) => AlertDialog(
        title: const Text("Editar Rutina"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl, 
              decoration: const InputDecoration(labelText: "Título de la rutina"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevoTitulo = tituloCtrl.text.trim();
              if (nuevoTitulo.isEmpty) return;
              
              final rutinaEditada = rutina.copyWith(titulo: nuevoTitulo);
              
              // 🛠️ CORREGIDO: Usamos listen: false explícito antes de cerrar el modal
              await Provider.of<RutinaProvider>(context, listen: false).actualizarRutina(rutinaEditada);
              
              // 🛠️ CORREGIDO: Para cerrar el diálogo de forma segura tras un await, 
              // usamos el context nativo verificado del árbol principal.
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Guardar"),
          )
        ],
      ),
    ).then((_) => tituloCtrl.dispose()); // Limpieza de memoria del controlador temporal
  }

  @override
  Widget build(BuildContext context) {
    final rutinaProvider = Provider.of<RutinaProvider>(context);

    // Cálculos automáticos para la barra de progreso superior
    final total = rutinaProvider.rutinas.length;
    final completadas = rutinaProvider.rutinas.where((r) => r.completado).length;
    final progreso = total == 0 ? 0.0 : completadas / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🗓️ Mis Rutinas"), 
        backgroundColor: Colors.teal, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjeta de progreso visual
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Progreso Diario", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progreso, 
                      color: Colors.blue, 
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 10),
                    Text("$completadas de $total completadas"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Input para añadir nuevas rutinas de forma ágil
            TextField(
              controller: tituloController, 
              decoration: const InputDecoration(
                labelText: "Nueva rutina (ej. Meditar, Estirar)", 
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Agregar Rutina"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, 
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () async {
                final texto = tituloController.text.trim();
                if (texto.isEmpty) return;
                
                await rutinaProvider.agregarRutina(texto);
                tituloController.clear();
                if (mounted) FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 20),
            
            // Listado Dinámico conectado a SQLite
            Expanded(
              child: rutinaProvider.rutinas.isEmpty
                  ? const Center(child: Text("No tienes rutinas asignadas para hoy.", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: rutinaProvider.rutinas.length,
                      itemBuilder: (_, index) {
                        final rutina = rutinaProvider.rutinas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Checkbox(
                              value: rutina.completado, 
                              onChanged: (_) => rutinaProvider.toggleRutina(rutina),
                            ),
                            title: Text(
                              rutina.titulo, 
                              style: TextStyle(
                                decoration: rutina.completado ? TextDecoration.lineThrough : null, 
                                color: rutina.completado ? Colors.grey : Colors.black,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue), 
                                  onPressed: () => mostrarDialogoEditar(rutina),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent), 
                                  onPressed: () => rutinaProvider.eliminarRutina(rutina.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}