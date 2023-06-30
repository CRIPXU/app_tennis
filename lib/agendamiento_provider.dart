import 'package:flutter/material.dart';

import 'database_provider.dart';
import 'model_agendamiento.dart';

class AgendamientosProvider extends ChangeNotifier {
  List<Agendamiento> _agendamientos = [];

  List<Agendamiento> get agendamientos => _agendamientos;

  Future<void> loadAgendamientos() async {
    _agendamientos = await DatabaseProvider.instance.getAgendamientos(); // Método para obtener los agendamientos desde la base de datos o cualquier otra fuente
    notifyListeners();
  }

  Future<void> fetchAgendamientos() async {
    _agendamientos = await DatabaseProvider.instance.getAgendamientos();
    notifyListeners();
  }

  Future<void> insertAgendamiento(Agendamiento agendamiento) async {
    await DatabaseProvider.instance.insertAgendamiento(agendamiento);
    await fetchAgendamientos();
    notifyListeners();
  }

  Future<void> deleteAgendamiento(int id) async {
    await DatabaseProvider.instance.deleteAgendamiento(id);
    await fetchAgendamientos();
  }
}
