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
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<RutinaProvider>(context, listen: false).cargarRutinas();
    });
  }

  void mostrarDialogoEditar(Rutina rutina) {
    TextEditingController editController = TextEditingController(text: rutina.titulo);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Rutina"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: "Título"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editController.text.trim().isEmpty) return;
                rutina.titulo = editController.text.trim();
                await Provider.of<RutinaProvider>(context, listen: false)
                    .actualizarRutina(rutina);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rutinaProvider = Provider.of<RutinaProvider>(context);
    final listado = rutinaProvider.rutinas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 Mis Rutinas"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Sección superior de ingreso
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Escribe una nueva rutina...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 48, color: Colors.teal),
                  onPressed: () async {
                    if (controller.text.trim().isEmpty) return;
                    
                    final nueva = Rutina(
                      titulo: controller.text.trim(),
                      fecha: DateTime.now().toString(),
                    );
                    
                    await rutinaProvider.agregarRutina(nueva);
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Mapeo e impresión del listado asíncrono
            if (listado.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(
                  child: Text(
                    "No hay rutinas guardadas.\n¡Ingresa una arriba para comenzar!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              ...listado.map((item) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: item.completado,
                      onChanged: (_) {
                        rutinaProvider.toggleRutina(item);
                      },
                    ),
                    title: Text(
                      item.titulo,
                      style: TextStyle(
                        decoration: item.completado ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => mostrarDialogoEditar(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => rutinaProvider.eliminarRutina(item.id!),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}