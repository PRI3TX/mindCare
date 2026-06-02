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
      Provider.of<RutinaProvider>(
        context,
        listen: false,
      ).cargarRutinas();
    });
  }

  void mostrarDialogoEditar(Rutina rutina) {
    TextEditingController editController =
        TextEditingController(text: rutina.titulo);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Rutina"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: "Título",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                rutina.titulo = editController.text;

                await Provider.of<RutinaProvider>(
                  context,
                  listen: false,
                ).actualizarRutina(rutina);

                Navigator.pop(context);
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

    int total = rutinaProvider.rutinas.length;

    int completadas = rutinaProvider.rutinas
        .where((r) => r.completado)
        .length;

    double progreso =
        total == 0 ? 0 : completadas / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 Mis Rutinas"),
        centerTitle: true,
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
                      "Progreso Diario",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    LinearProgressIndicator(
                      value: progreso,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$completadas de $total completadas",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Nueva rutina",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () async {
                    if (controller.text.isEmpty) return;

                    await rutinaProvider.agregarRutina(
                      Rutina(
                        titulo: controller.text,
                        fecha: DateTime.now()
                            .toString(),
                      ),
                    );

                    controller.clear();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount:
                    rutinaProvider.rutinas.length,
                itemBuilder: (context, index) {
                  final rutina =
                      rutinaProvider.rutinas[index];

                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: rutina.completado,
                        onChanged: (_) {
                          rutinaProvider
                              .toggleRutina(rutina);
                        },
                      ),

                      title: Text(
                        rutina.titulo,
                        style: TextStyle(
                          decoration:
                              rutina.completado
                                  ? TextDecoration
                                      .lineThrough
                                  : null,
                        ),
                      ),

                      subtitle: Text(
                        rutina.fecha.substring(0, 10),
                      ),

                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              mostrarDialogoEditar(
                                  rutina);
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              rutinaProvider
                                  .eliminarRutina(
                                rutina.id!,
                              );
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