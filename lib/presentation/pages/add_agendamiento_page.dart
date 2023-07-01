import 'package:cancha_tennis/application/providers/agendamiento_provider.dart';
import 'package:cancha_tennis/domain/models/model_agendamiento.dart';
import 'package:cancha_tennis/infrastructure/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../widgets/loading_custom.dart';

class AddAgendamientoPage extends StatefulWidget {
  const AddAgendamientoPage({super.key});

  @override
  _AddAgendamientoPageState createState() => _AddAgendamientoPageState();
}

class _AddAgendamientoPageState extends State<AddAgendamientoPage> {
  //VAR
  int? selectedCancha;
  DateTime? selectedDate;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  AgendamientosProvider? _agendamientosProvider;
  final DatabaseProvider dbProvider = DatabaseProvider.instance;

  //Controller
  final TextEditingController nombreController = TextEditingController();

  final Map<int, String> canchas = {
    0: 'A',
    1: 'B',
    2: 'C',
  };

  //Metodos

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
      Navigator.pushReplacementNamed(context, '/home');
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _agendamientosProvider ??= Provider.of<AgendamientosProvider>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    nombreController.dispose();
    _agendamientosProvider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, value, __) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('📃Agregar Agendamiento📃'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('images/ball.json',
                        fit: BoxFit.cover, height: 150),
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
                      decoration: const InputDecoration(labelText: 'Usuario'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      child: const Text('Seleccionar Fecha'),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        isLoading.value = true;

                        await Future.delayed(const Duration(seconds: 3));

                        isLoading.value = false;

                        saveAgendamiento();
                        // Aquí debes implementar la lógica para guardar el agendamiento localmente
                        //Navigator.pop(context);
                      },
                      child: const Text('Guardar Agendamiento'),
                    ),
                  ],
                ),
              ),
            ),
            if (value) const Positioned.fill(child: Center(child: LoadingCustom()))
          ],
        );
      },
    );
  }
}


