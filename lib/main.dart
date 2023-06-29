import 'package:cancha_tennis/model_agendamiento.dart';
import 'package:flutter/material.dart';

import 'database_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseProvider.instance.initializeDatabaseProvider();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamiento de Canchas de Tenis',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<List<Agendamiento>>(
        future: DatabaseProvider.instance.getAgendamientos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)   {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final agendamientos = snapshot.data!;
            return HomePage(agendamientos: agendamientos);
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Agendamiento> agendamientos;

  HomePage({required this.agendamientos});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamientos de Canchas de Tenis'),
      ),
      body: ListView.builder(
     itemCount: agendamientos.length,
        itemBuilder: (context, index) {
          final agendamiento = agendamientos[index];
          return ListTile(
            title: Text(agendamiento.cancha),
            subtitle: Text(agendamiento.fecha),
            trailing: Text(agendamiento.usuario),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAgendamientoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddAgendamientoPage extends StatefulWidget {
  @override
  _AddAgendamientoPageState createState() => _AddAgendamientoPageState();
}

class _AddAgendamientoPageState extends State<AddAgendamientoPage> {
  //VAR
  final DatabaseProvider dbProvider = DatabaseProvider.instance;
  int? selectedCancha;
  DateTime? selectedDate;
  final TextEditingController nombreController = TextEditingController();

  //Metodos
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Aquí puedes hacer una llamada a una API para obtener el porcentaje de probabilidad de lluvia para la fecha seleccionada
      // y mostrarlo en pantalla
    }
  }

  final Map<int, String> canchas = {
    0: 'A',
    1: 'B',
    2: 'C',
  };

  //Guardar
  // void saveAgendamiento() async {
  //   final agendamiento = Agendamiento(
  //     id: 0,
  //     cancha: selectedCancha.toString(),
  //     fecha: selectedDate.toString(),
  //     usuario: nombreController.text,
  //   );
  //   await dbProvider.insertAgendamiento(agendamiento);
  // }

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

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   nombreController.dispose();
  // }

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
            //   items: ['A', 'B', 'C'].asMap().entries.map<DropdownMenuItem<int>>(
            //     (entry) {
            //       final int index = entry.key;
            //       final String value = entry.value;
            //       return DropdownMenuItem<int>(
            //         value: index,
            //         child: Text('Cancha $value'),
            //       );
            //     },
            //   ).toList(),
            //   decoration: const InputDecoration(
            //     labelText: 'Cancha',
            //   ),
            // ),
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
            // DateTimePicker(
            //   initialValue: DateTime.now().toString(),
            //   firstDate: DateTime.now(),
            //   lastDate: DateTime.now().add(Duration(days: 365)),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedDate = DateTime.parse(value);
            //     });
            //   },
            // ),
            // InkWell(
            //   onTap: () {
            //     _selectDate(context);
            //   },
            //   child: InputDecorator(
            //     decoration: const InputDecoration(
            //       labelText: 'Fecha',
            //       suffixIcon: Icon(Icons.calendar_today),
            //     ),
            //     child: Text(
            //       selectedDate != null
            //           ? '${selectedDate!.day}/${selectedDate!
            //           .month}/${selectedDate!.year}'
            //           : 'Seleccione una fecha',
            //       style: const TextStyle(fontSize: 16.0),
            //     ),
            //   ),
            // ),
            // Aquí puedes añadir el campo para el nombre de la persona realizando el agendamiento
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                saveAgendamiento();
                // Aquí debes implementar la lógica para guardar el agendamiento localmente
                Navigator.pop(context);
              },
              child: const Text('Guardar Agendamiento'),
            ),
          ],
        ),
      ),
    );
  }

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

    await dbProvider.insertAgendamiento(agendamiento);
  }
}
