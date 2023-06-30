import 'package:cancha_tennis/application/providers/agendamiento_provider.dart';
import 'package:cancha_tennis/domain/models/model_agendamiento.dart';
import 'package:cancha_tennis/infrastructure/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class AddAgendamientoPage extends StatefulWidget {
  const AddAgendamientoPage({super.key});

  @override
  _AddAgendamientoPageState createState() => _AddAgendamientoPageState();
}

class _AddAgendamientoPageState extends State<AddAgendamientoPage> {
  //VAR
  final DatabaseProvider dbProvider = DatabaseProvider.instance;
  int? selectedCancha;
  DateTime? selectedDate;
  final TextEditingController nombreController = TextEditingController();

  final Map<int, String> canchas = {
    0: 'A',
    1: 'B',
    2: 'C',
  };

  //Guardar
  void saveAgendamiento() async {
    if (selectedCancha == null || selectedDate == null) {
      return;
    }

    final agendamiento = Agendamiento(
      id: 0,
      cancha: canchas[selectedCancha!]!,
      fecha: selectedDate.toString(),
      usuario: nombreController.text,
    );

    final agendamientosProvider =
    Provider.of<AgendamientosProvider>(context, listen: false);
    final agendamientoGuardado =
    await agendamientosProvider.insertAgendamiento(agendamiento);

    if (agendamientoGuardado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No hay disponibilidad'),
            content: const Text(
                'Ya se han agendado tres veces para esa cancha en ese día.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  //Obtener
  Future<List<Agendamiento>> getAgendamientos() async {
    return await dbProvider.getAgendamientos();
  }

  //Delete
  void deleteAgendamiento(int id) async {
    await dbProvider.deleteAgendamiento(id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseProvider;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nombreController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Agendamiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedCancha,
              onChanged: (value) {
                setState(() {
                  selectedCancha = value;
                });
              },
              items: canchas.entries.map<DropdownMenuItem<int>>(
                    (entry) {
                  final int index = entry.key;
                  final String value = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Text('Cancha $value'),
                  );
                },
              ).toList(),
              decoration: const InputDecoration(
                labelText: 'Cancha',
              ),
            ),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Seleccionar Fecha'),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                });
              },
            ),
            // Aquí puedes añadir el campo para el nombre de la persona realizando el agendamiento
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveAgendamiento();
                // Aquí debes implementar la lógica para guardar el agendamiento localmente
                //Navigator.pop(context);
              },
              child: const Text('Guardar Agendamiento'),
            ),
          ],
        ),
      ),
    );
  }
}