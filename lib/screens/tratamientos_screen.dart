import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tratamiento.dart';
import '../providers/tratamiento_provider.dart';
import '../providers/auth_provider.dart'; 

class TratamientosScreen extends StatefulWidget {
  const TratamientosScreen({super.key});

  @override
  State<TratamientosScreen> createState() => _TratamientosScreenState();
}

class _TratamientosScreenState extends State<TratamientosScreen> {
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userId = Provider.of<AuthProvider>(context, listen: false).usuarioIdActual;
      Provider.of<TratamientoProvider>(context, listen: false).cargarTratamientos(userId); 
    });
  }

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
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: descripcionCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
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

              // 🛠️ SOLUCIÓN (Imagen 5): Creamos la copia con los nuevos textos
              final tratamientoEditado = tratamiento.copyWith(
                nombre: nombreCtrl.text.trim(),
                descripcion: descripcionCtrl.text.trim(),
              );

              await Provider.of<TratamientoProvider>(
                context,
                listen: false,
              ).actualizarTratamiento(tratamientoEditado);

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
    final provider = Provider.of<TratamientoProvider>(context);
    final userId = Provider.of<AuthProvider>(context).usuarioIdActual;
    
    final total = provider.tratamientos.length;
    final completados = provider.tratamientos.where((t) => t.completado).length;
    final progreso = total == 0 ? 0.0 : completados / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text("💊 Tratamientos"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "Progreso",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(value: progreso),
                    const SizedBox(height: 10),
                    Text("$completados de $total completados"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nombre tratamiento"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Agregar"),
              onPressed: () async {
                if (nombreController.text.trim().isEmpty) return;

                await provider.agregarTratamiento(
                  Tratamiento(
                    usuarioId: userId, 
                    nombre: nombreController.text.trim(),
                    descripcion: descripcionController.text.trim(),
                    fecha: DateTime.now().toString(),
                  ),
                );

                nombreController.clear();
                descripcionController.clear();
                if (context.mounted) FocusScope.of(context).unfocus();
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: provider.tratamientos.isEmpty
                  ? const Center(child: Text("No tienes tratamientos registrados."))
                  : ListView.builder(
                      itemCount: provider.tratamientos.length,
                      itemBuilder: (_, index) {
                        final tratamiento = provider.tratamientos[index];

                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tratamiento.completado,
                              onChanged: (_) => provider.toggleTratamiento(tratamiento),
                            ),
                            title: Text(
                              tratamiento.nombre,
                              style: TextStyle(
                                decoration: tratamiento.completado
                                    ? TextDecoration.lineThrough
                                    : null,
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
                                  onPressed: () {
                                    provider.eliminarTratamiento(tratamiento.id!, userId);
                                  },
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