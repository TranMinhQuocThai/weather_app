import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'PQ2X6XDUTK5STGNXGW7YGAX6L'; // Thay YOUR_API_KEY bằng API key của bạn từ Visual Crossing

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    String cityurl = city.replaceAll(' ', '%20');
    final response = await http.get(Uri.parse(
        'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$cityurl?unitGroup=metric&key=$apiKey&contentType=json'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // In ra thông tin lỗi để dễ dàng kiểm tra
      print('Error: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load weather data');
    }
  }
}