import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<int> obtenerProbabilidadLluvia(String fecha) async {
    // Make an HTTP request to the weather API
    final response = await http.get(Uri.parse('https://api.tutiempo.net/json/?lan=es&apid=zxYqz44qXX4fli6&lid=3768'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final dayData = jsonData['day1'];

      // Obtain the rain probability from the API response
      final rainProbability = dayData['humidity'] as int;
      return rainProbability;
    } else {
      throw Exception('Error al obtener datos meteorológicos');
    }
  }
}

