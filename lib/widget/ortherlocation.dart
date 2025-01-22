import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import thư viện để sử dụng SVG
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../service/weather_api.dart';

const cities = [
  "An Giang",
  "Ba Ria - Vung Tau",
  "Bac Giang",
  "Bac Kan",
  "Bac Lieu",
  "Bac Ninh",
  "Ben Tre",
  "Binh Dinh",
  "Binh Duong",
  "Binh Phuoc",
  "Binh Thuan",
  "Ca Mau",
  "Can Tho",
  "Cao Bang",
  "Da Nang",
  "Dak Lak",
  "Dak Nong",
  "Dien Bien",
  "Dong Nai",
  "Dong Thap",
  "Gia Lai",
  "Ha Giang",
  "Ha Nam",
  "Ha Noi",
  "Ha Tinh",
  "Hai Duong",
  "Hai Phong",
  "Hau Giang",
  "Hoa Binh",
  "Hung Yen",
  "Khanh Hoa",
  "Kien Giang",
  "Kon Tum",
  "Lai Chau",
  "Lam Dong",
  "Lang Son",
  "Lao Cai",
  "Long An",
  "Nam Dinh",
  "Nghe An",
  "Ninh Binh",
  "Ninh Thuan",
  "Phu Tho",
  "Phu Yen",
  "Quang Binh",
  "Quang Nam",
  "Quang Ngai",
  "Quang Ninh",
  "Quang Tri",
  "Soc Trang",
  "Son La",
  "Tay Ninh",
  "Thai Binh",
  "Thai Nguyen",
  "Thanh Hoa",
  "Thua Thien Hue",
  "Tien Giang",
  "TP Ho Chi Minh",
  "Tra Vinh",
  "Tuyen Quang",
  "Vinh Long",
  "Vinh Phuc",
  "Yen Bai"
];



class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  final weatherService = WeatherService();
  final List<Map<String, dynamic>?> weatherData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    for (var city in cities) {
      final weather = await weatherService.fetchWeather(city);
      setState(() {
        weatherData.add(weather);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(0.0),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: weatherData.map((weather) => _WeatherCard(weather)).toList(),
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Map<String, dynamic>? weather;

  const _WeatherCard(this.weather, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (weather == null) {
      return const Center(child: Text('Lỗi oyyyy'));
    }

    final location = weather?['address'];
    final temp = weather?['currentConditions']['temp'];
    final weatherDescription = weather?['currentConditions']['description'];
    final weatherIcon = weather?['currentConditions']['icon'].toLowerCase();
     final tempMax = weather?['days'][0]['tempmax']; // Thêm nhiệt độ cao nhất
    final tempMin = weather?['days'][0]['tempmin']; // Thêm nhiệt độ thấp nhất

    return Card(
      color: Colors.white.withOpacity(0.8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Điều chỉnh để tránh overflow
          children: [
            Text(
              location?? '',
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SvgPicture.asset(
              'assets/status/${weatherIcon ?? "default"}.svg', // Thêm icon SVG
              height: 50,
              width: 50,
            ),
            const SizedBox(height: 10),
            Text(
              '${temp ?? 'N/A'}°C',
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            ),
       
                  const SizedBox(height: 5),
            // Hiển thị nhiệt độ cao nhất và thấp nhất
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Max: ${tempMax.round() ?? 'N/A'}°C',
                  style: const TextStyle(fontSize: 14.0, color: Colors.redAccent),
                ),
                Text(
                  'Min: ${tempMin.round() ?? 'N/A'}°C',
                  style: const TextStyle(fontSize: 14.0, color: Colors.blueAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

