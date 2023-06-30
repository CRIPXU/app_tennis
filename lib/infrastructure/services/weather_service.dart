import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey = '9521e16f9d6c4d0bad8140730233006';
  final String baseUrl = 'http://api.weatherapi.com/v1/forecast.json';

  Future<int> getRainProbability(String location, String date) async {
    final response = await http.get(Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=9521e16f9d6c4d0bad8140730233006&q=$location&dt=$date&aqi=yes&alerts=yes'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final dayData = jsonData['forecast']['forecastday'][0];
      final rainProbability = dayData['day']['daily_chance_of_rain'] as int;
      return rainProbability;
    } else {
      throw Exception('Error al obtener la probabilidad de lluvia');
    }
  }
}
