import 'package:cached_network_image/cached_network_image.dart';
import 'package:cancha_tennis/infrastructure/services/weather_service.dart';
import 'package:cancha_tennis/presentation/pages/add_agendamiento_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../application/providers/agendamiento_provider.dart';
import '../widgets/widget_avatar.dart';
import '../widgets/widget_content_info.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Var
  final WeatherService weatherService = WeatherService();
  String rainAnimationFile = 'heavy_rain.json';

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
  Future<void> updateRainAnimationFile(int rainProbability) async {
    if (rainProbability != null) {
      if (rainProbability > 81) {
        rainAnimationFile = 'heavy_rain.json';
      } else if (rainProbability > 50) {
        rainAnimationFile = 'moderate_rain.json';
      } else {
        rainAnimationFile = 'sun.json';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[800],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 220.0,
              floating: true,
              snap: false,
              elevation: 5,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                title: Text(
                  'Tennis App',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.lightGreen[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: CachedNetworkImage(
                  placeholder: (context, url) {
                    return Image.network(
                      'https://i.pinimg.com/564x/ff/42/4a/ff424a8878366f72c1e02a0a7c965935.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                  imageUrl:
                      'https://i.pinimg.com/564x/ff/42/4a/ff424a8878366f72c1e02a0a7c965935.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24), color: Colors.white),
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


                  return Stack(
                    children: [
                      CachedNetworkImage(
                        placeholder: (context, url) => Image.network(
                          'https://i.pinimg.com/564x/1b/8e/94/1b8e94207f7ce4369d654bcb516c1212.jpg',
                          fit: BoxFit.cover,
                          isAntiAlias: true,
                          color: Colors.lightGreen,
                          colorBlendMode: BlendMode.hue,
                        ),
                        imageUrl:
                            'https://i.pinimg.com/564x/1b/8e/94/1b8e94207f7ce4369d654bcb516c1212.jpg',
                        fit: BoxFit.cover,
                        color: Colors.lightGreen,
                        colorBlendMode: BlendMode.hue,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 150),
                        child: Text(
                          'Cancha: ${agendamiento.cancha}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 220, top: 10),
                        child: SizedBox(
                          child: Lottie.asset(
                            'images/$rainAnimationFile',
                            width: 300,
                            height: 180,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                avatar(
                                    urlImage:
                                        'https://i.pinimg.com/564x/1e/00/88/1e0088fd384c97dfe1f298c73673adcf.jpg'),
                                const SizedBox(width: 10),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 28),
                                  child: Text(
                                    'Usuario: ${agendamiento.usuario}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                contentInfo(
                                  icon: const Icon(Icons.date_range),
                                  text: Text(
                                    'fecha: ${formattedDate}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                FutureBuilder<int>(
                                  future:
                                  weatherService.getRainProbability('Caracas', formattedDate),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return const Text(
                                        'Probabilidad de lluvia: 0%',
                                        style: TextStyle(color: Colors.black),
                                      );
                                    } else {
                                      final rainProbability = snapshot.data;

                                      // Actualizar el archivo de animación de lluvia
                                      updateRainAnimationFile(rainProbability!);

                                      return contentInfo(
                                          icon: const Icon(Icons.cloud),
                                          text: Text(
                                            'Probabilidad de lluvia:  $rainProbability%',
                                            style:
                                                const TextStyle(color: Colors.black),
                                          ));
                                      // Text(
                                      //   '$rainProbability%');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 30,
                          ),
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
                                            .deleteAgendamiento(
                                                agendamiento.id);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
        child: const Icon(Icons.border_color_outlined),
      ),
    );
  }
}
