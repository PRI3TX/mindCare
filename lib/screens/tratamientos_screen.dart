import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tratamiento.dart';
import '../providers/tratamiento_provider.dart';

class TratamientosScreen extends StatefulWidget {
  const TratamientosScreen({super.key});

  @override
  State<TratamientosScreen> createState() =>
      _TratamientosScreenState();
}

class _TratamientosScreenState
    extends State<TratamientosScreen> {

  final nombreController =
      TextEditingController();

  final descripcionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TratamientoProvider>(
        context,
        listen: false,
      ).cargarTratamientos();
    });
  }

  void mostrarDialogoEditar(
      Tratamiento tratamiento) {

    final nombre =
        TextEditingController(
      text: tratamiento.nombre,
    );

    final descripcion =
        TextEditingController(
      text: tratamiento.descripcion,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
            "Editar Tratamiento"),
        content: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller: nombre,
              decoration:
                  const InputDecoration(
                labelText: "Nombre",
              ),
            ),
            TextField(
              controller: descripcion,
              decoration:
                  const InputDecoration(
                labelText:
                    "Descripción",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child:
                const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {

              tratamiento.nombre =
                  nombre.text;

              tratamiento
                      .descripcion =
                  descripcion.text;

              await Provider.of<
                  TratamientoProvider>(
                context,
                listen: false,
              ).actualizarTratamiento(
                  tratamiento);

              Navigator.pop(context);
            },
            child:
                const Text("Guardar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider =
        Provider.of<
            TratamientoProvider>(
      context,
    );

    final total =
        provider.tratamientos.length;

    final completados =
        provider.tratamientos
            .where(
              (t) =>
                  t.completado,
            )
            .length;

    final progreso = total == 0
        ? 0.0
        : completados / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "💊 Tratamientos"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              elevation: 4,
              child: Padding(
                padding:
                    const EdgeInsets
                        .all(16),
                child: Column(
                  children: [
                    const Text(
                      "Progreso",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    const SizedBox(
                        height: 10),
                    LinearProgressIndicator(
                      value: progreso,
                    ),
                    const SizedBox(
                        height: 10),
                    Text(
                      "$completados de $total completados",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(
              controller:
                  nombreController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Nombre tratamiento",
              ),
            ),

            const SizedBox(
                height: 10),

            TextField(
              controller:
                  descripcionController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Descripción",
              ),
            ),

            const SizedBox(
                height: 10),

            ElevatedButton.icon(
              icon: const Icon(
                  Icons.add),
              label: const Text(
                  "Agregar"),
              onPressed: () async {

                if (nombreController
                    .text
                    .isEmpty) {
                  return;
                }

                await provider
                    .agregarTratamiento(
                  Tratamiento(
                    nombre:
                        nombreController
                            .text,
                    descripcion:
                        descripcionController
                            .text,
                    fecha:
                        DateTime.now()
                            .toString(),
                  ),
                );

                nombreController
                    .clear();

                descripcionController
                    .clear();
              },
            ),

            const SizedBox(
                height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: provider
                    .tratamientos
                    .length,
                itemBuilder:
                    (_, index) {

                  final tratamiento =
                      provider
                          .tratamientos[index];

                  return Card(
                    child: ListTile(
                      leading:
                          Checkbox(
                        value:
                            tratamiento
                                .completado,
                        onChanged:
                            (_) {
                          provider
                              .toggleTratamiento(
                            tratamiento,
                          );
                        },
                      ),

                      title: Text(
                        tratamiento
                            .nombre,
                      ),

                      subtitle:
                          Text(
                        tratamiento
                            .descripcion,
                      ),

                      trailing:
                          Row(
                        mainAxisSize:
                            MainAxisSize
                                .min,
                        children: [

                          IconButton(
                            icon:
                                const Icon(
                              Icons
                                  .edit,
                              color:
                                  Colors.blue,
                            ),
                            onPressed:
                                () {
                              mostrarDialogoEditar(
                                  tratamiento);
                            },
                          ),

                          IconButton(
                            icon:
                                const Icon(
                              Icons
                                  .delete,
                              color:
                                  Colors.red,
                            ),
                            onPressed:
                                () {
                              provider
                                  .eliminarTratamiento(
                                tratamiento
                                    .id!,
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