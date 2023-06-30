import 'package:cancha_tennis/infrastructure/services/weather_service.dart';
import 'package:cancha_tennis/presentation/pages/add_agendamiento_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../application/providers/agendamiento_provider.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    final agendamientosProvider =
    Provider.of<AgendamientosProvider>(context, listen: false);
    agendamientosProvider.loadAgendamientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamientos de Canchas de Tenis'),
      ),
      body: Consumer<AgendamientosProvider>(
        builder: (context, provider, _) {
          final agendamientos = provider.agendamientos;
          // Ordenar los agendamientos por fecha (de forma ascendente)
          agendamientos.sort((a, b) => a.fecha.compareTo(b.fecha));

          return ListView.builder(
            itemCount: agendamientos.length,
            itemBuilder: (context, index) {
              final agendamiento = agendamientos[index];

              // Formatear la fecha de manera legible
              final formattedDate = DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(agendamiento.fecha));

              return ListTile(
                title: Text('Cancha: ${agendamiento.cancha}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Usuario: ${agendamiento.usuario}'),
                    Text(formattedDate),
                    FutureBuilder<int>(
                      future: weatherService
                          .obtenerProbabilidadLluvia(agendamiento.fecha),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                              'Error al obtener la probabilidad de lluvia');
                        } else {
                          final probabilidadLluvia = snapshot.data;
                          return Text(
                              'Probabilidad de lluvia: $probabilidadLluvia%');
                        }
                      },
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Usuario: ${agendamiento.usuario}'),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Confirmar'),
                              content:
                              const Text('¿Desea borrar el agendamiento?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text('borrar'),
                                  onPressed: () {
                                    final agendamientosProvider =
                                    Provider.of<AgendamientosProvider>(context, listen: false);
                                    agendamientosProvider.deleteAgendamiento(agendamiento.id);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddAgendamientoPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}