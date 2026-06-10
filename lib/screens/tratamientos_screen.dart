import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tratamiento.dart';
import '../providers/tratamiento_provider.dart';

class TratamientosScreen extends StatefulWidget {
  const TratamientosScreen({super.key});

  @override
  State<TratamientosScreen> createState() => _TratamientosScreenState();
}

class _TratamientosScreenState extends State<TratamientosScreen> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  void mostrarDialogoEditar(Tratamiento tratamiento) {
    final nombreCtrl = TextEditingController(text: tratamiento.nombre);
    final descripcionCtrl = TextEditingController(text: tratamiento.descripcion);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Tratamiento"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre")),
            const SizedBox(height: 10),
            TextField(controller: descripcionCtrl, decoration: const InputDecoration(labelText: "Descripción")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nombreCtrl.text.trim().isEmpty) return;
              final tratamientoEditado = tratamiento.copyWith(
                nombre: nombreCtrl.text.trim(), 
                descripcion: descripcionCtrl.text.trim(),
              );
              await Provider.of<TratamientoProvider>(context, listen: false).actualizarTratamiento(tratamientoEditado);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Guardar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tratamientoProvider = Provider.of<TratamientoProvider>(context);
    
    // Cálculo de métricas locales en tiempo real
    final total = tratamientoProvider.tratamientos.length;
    final completados = tratamientoProvider.tratamientos.where((t) => t.completado).length;
    final progreso = total == 0 ? 0.0 : completados / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text("💊 Mis Tratamientos"), 
        backgroundColor: Colors.teal, 
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Módulo de Progreso
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Progreso de Hábitos / Fármacos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: progreso,
                      color: Colors.orange,
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 10),
                    Text("$completados de $total completados"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Formulario de Inserción rápida
            TextField(
              controller: nombreController, 
              decoration: const InputDecoration(labelText: "Nombre del tratamiento (ej. Vitaminas)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController, 
              decoration: const InputDecoration(labelText: "Indicación / Dosis (ej. 1 cápsula en el desayuno)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Agregar Tratamiento"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, 
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final desc = descripcionController.text.trim();
                if (nombre.isEmpty) return;

                // 🛠️ CRUD CONTROLADO: El Provider maneja el usuarioId internamente por debajo
                await tratamientoProvider.agregarTratamiento(nombre, desc);
                
                nombreController.clear();
                descripcionController.clear();
                if (context.mounted) FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 20),
            
            // Render de Registros Activos desde Base de Datos
            Expanded(
              child: tratamientoProvider.tratamientos.isEmpty
                  ? const Center(child: Text("No tienes tratamientos registrados.", style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: tratamientoProvider.tratamientos.length,
                      itemBuilder: (_, index) {
                        final tratamiento = tratamientoProvider.tratamientos[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: Checkbox(
                              value: tratamiento.completado, 
                              onChanged: (_) => tratamientoProvider.toggleTratamiento(tratamiento),
                            ),
                            title: Text(
                              tratamiento.nombre, 
                              style: TextStyle(
                                decoration: tratamiento.completado ? TextDecoration.lineThrough : null,
                                color: tratamiento.completado ? Colors.grey : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(tratamiento.descripcion),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue), 
                                  onPressed: () => mostrarDialogoEditar(tratamiento),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent), 
                                  onPressed: () => tratamientoProvider.eliminarTratamiento(tratamiento.id!),
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