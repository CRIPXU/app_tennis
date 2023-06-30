import 'package:flutter/material.dart';

import 'database_provider.dart';
import 'model_agendamiento.dart';

class AgendamientosProvider extends ChangeNotifier {
  List<Agendamiento> _agendamientos = [];

  List<Agendamiento> get agendamientos => _agendamientos;

  // Mapa para realizar un seguimiento de la cantidad de agendamientos por día y cancha
  final Map<String, int> agendamientosPorDia = {};

  Future<void> loadAgendamientos() async {
    _agendamientos = await DatabaseProvider.instance
        .getAgendamientos(); // Método para obtener los agendamientos desde la base de datos o cualquier otra fuente
    notifyListeners();
  }

  Future<void> fetchAgendamientos() async {
    _agendamientos = await DatabaseProvider.instance.getAgendamientos();
    notifyListeners();
  }

  Future<bool> insertAgendamiento(Agendamiento agendamiento) async {
    // Obtener la clave del mapa para la fecha y la cancha seleccionadas
    final key = '${agendamiento.fecha}-${agendamiento.cancha}';
    // Verificar si ya se han agendado tres veces para la cancha en el día seleccionado
    if (agendamientosPorDia[key] != null && agendamientosPorDia[key]! >= 3) {
      return false;
      // O mostrar un mensaje de error en lugar de lanzar una excepción
      // y manejarlo adecuadamente en el código que llama a insertAgendamiento.
    }
    await DatabaseProvider.instance.insertAgendamiento(agendamiento);
    await fetchAgendamientos();
    // Incrementar la cantidad de agendamientos para la cancha y día correspondientes
    agendamientosPorDia.update(key, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
    return true;
  }

  Future<void> deleteAgendamiento(int id) async {
    await DatabaseProvider.instance.deleteAgendamiento(id);
    await fetchAgendamientos();
  }
}
