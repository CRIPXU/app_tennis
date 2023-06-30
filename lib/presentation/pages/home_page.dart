import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancha_tennis/infrastructure/services/weather_service.dart';
import 'package:cancha_tennis/presentation/pages/add_agendamiento_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../application/providers/agendamiento_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();
  String rainAnimationFile = 'rain.json';

  @override
  void initState() {
    super.initState();
    final agendamientosProvider =
        Provider.of<AgendamientosProvider>(context, listen: false);
    agendamientosProvider.loadAgendamientos();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //Metodos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: NestedScrollView(
        //headerSliverBuilder: (context, innerBoxIsScrolled) {
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 220.0,
              floating: true,
              snap: false,
              elevation: 5,
              flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                expandedTitleScale: 1,
                title: const Text('Agenda',style: TextStyle(fontSize: 15),),
                background: CachedNetworkImage(
                  placeholder: (context, url) {
                    return Image.network(
                      'https://i.pinimg.com/564x/14/70/d6/1470d68361088829e4faf64555f94a98.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                  imageUrl:
                      'https://i.pinimg.com/564x/1f/32/31/1f3231213a41a42089ffd90365ddcc59.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),color: Colors.black26),
          child: Consumer<AgendamientosProvider>(
            builder: (context, provider, _) {
              final agendamientos = provider.agendamientos;
              // Ordenar los agendamientos por fecha (de forma ascendente)
              agendamientos.sort((a, b) => a.fecha.compareTo(b.fecha));

              return ListView.builder(
                itemCount: agendamientos.length,
                itemBuilder: (context, index) {
                  final agendamiento = agendamientos[index];

                  // Formatear la fecha de manera legible
                  final formattedDate = DateFormat('yyyy-M-dd')
                      .format(DateTime.parse(agendamiento.fecha));

                  return ListTile(
                    title: Text('Cancha: ${agendamiento.cancha}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SafeArea(
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Lottie.asset(
                              'images/$rainAnimationFile',
                            ),
                          ),
                        ),
                        Text('Usuario: ${agendamiento.usuario}'),
                        Text(formattedDate),
                        FutureBuilder<int>(
                          future: weatherService.getRainProbability(
                              'Caracas', formattedDate),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text(
                                  'No tenemos registros de provabilidad de lluvia');
                            } else {
                              final rainProbability = snapshot.data;

                              // Cambiar el archivo de animación de lluvia según la probabilidad
                              if (rainProbability != null) {
                                rainAnimationFile = 'sun.json';
                                if (rainProbability > 50) {
                                  rainAnimationFile = 'rain.json';
                                } else if (rainProbability > 25) {
                                  rainAnimationFile = 'moderate_rain.json';
                                } else {
                                  rainAnimationFile = 'sun.json';
                                }
                              }

                              return Text(
                                  'Probabilidad de lluvia: $rainProbability%');
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
                                  content: const Text(
                                      '¿Desea borrar el agendamiento?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text('borrar'),
                                      onPressed: () {
                                        final agendamientosProvider =
                                            Provider.of<AgendamientosProvider>(
                                                context,
                                                listen: false);
                                        agendamientosProvider
                                            .deleteAgendamiento(agendamiento.id);
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
        ),
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
