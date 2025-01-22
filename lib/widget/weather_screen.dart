import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../service/weather_api.dart';
import './ortherlocation.dart';

void main() {
  runApp(weather());
}

class weather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController cityController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode để theo dõi trạng thái bàn phím
  bool isKeyboardVisible = false; // Trạng thái bàn phím

  String city = 'Hồ Chí Minh';
  Map<String, dynamic>? weatherData;
  String errorMessage = '';

 @override
void initState() {
  super.initState();
  // Gọi hàm fetchWeather khi ứng dụng bắt đầu để hiển thị thời tiết của Hồ Chí Minh
  cityController.text = 'Hồ Chí Minh'; // Đặt mặc định tên thành phố
  fetchWeather(); // Tải thời tiết của thành phố mặc định
  _focusNode.addListener(() {
    // Theo dõi trạng thái Focus (bàn phím bật/tắt)
    setState(() {
      isKeyboardVisible = _focusNode.hasFocus;
    });
  });
}

  @override
  void dispose() {
    _focusNode.dispose(); // Hủy FocusNode khi không cần nữa
    super.dispose();
  }

  void fetchWeather() async {
    if (cityController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter a city name.';
        weatherData = null;
      });
      return;
    }
try {
  var data = await weatherService.fetchWeather('${cityController.text}, VietNam');
  if (data != null) {
    setState(() {
      city = cityController.text.isNotEmpty
          ? cityController.text
          : 'Hồ Chí Minh';
      weatherData = {
        ...data,
        'dailyForecasts': data['daily'] // Dự báo 7 ngày
      };
      errorMessage = '';
    });
  } else {
    setState(() {
      errorMessage = 'No weather data found for the entered city.';
      weatherData = null;
    });
  }
} catch (e) {
  setState(() {
    errorMessage = 'Lỗi oyyyyy';
    weatherData = null;
  });
}

  }

  Widget _buildWeatherImage() {
    if (weatherData != null) {
      String condition =
          weatherData!['currentConditions']['icon'].toLowerCase();
      return SvgPicture.asset('assets/status/${condition}.svg', height: 200);
    }
    return SizedBox(height: 200); // Placeholder khi chưa có dữ liệu
  }

  Widget _buildWeatherDetails() {
    if (weatherData != null) {
      return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Độ ẩm',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('${weatherData!['currentConditions']['humidity']}%',
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chỉ số UV',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('${weatherData!['currentConditions']['uvindex']}',
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }

 Widget _build7DayForecast() {
  if (weatherData != null && weatherData!['days'] != null) {
    List<dynamic> dailyForecasts = weatherData!['days'];
  
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Padding(
      padding: const EdgeInsets.only(left: 16.0), // Thêm padding bên trái
      child: Text(
        'Dự báo thời tiết 7 ngày tới',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
          SizedBox(height: 10),
          Column(
            children: List.generate(7, (i) {
              var forecast = dailyForecasts[i+1]; // Dữ liệu ngày thứ i
              var svg=SvgPicture.asset('assets/status/${forecast!['icon'].toLowerCase()}.svg', height: 43);
              debugPrint(forecast!['icon'].toLowerCase());
              var date = DateTime.parse(forecast['datetime']); // Chuyển đổi datetime
              var temp = forecast['temp']; // Nhiệt độ
              var condition = forecast['conditions']; // Trạng thái thời tiết
              return ListTile(
                leading: svg,
                title: Text(
                  '${date.day}/${date.month}/${date.year}: ${temp.round()}°C - $condition',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  return SizedBox.shrink(); // Trả về widget rỗng nếu không có dữ liệu
}



 @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true,
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.lightBlueAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView( // Thêm SingleChildScrollView để có thể cuộn
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  TextField(
                    textCapitalization: TextCapitalization.words ,
                    maxLines: 1,
                    controller: cityController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                    ),
                    onSubmitted: (text) {
                      fetchWeather();
                    },
                  ),
                  SizedBox(height: 20),
                  if (errorMessage.isNotEmpty)
                    Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    )
                  else if (weatherData != null)
                    Column(
                      children: [
                        Text(
                          'THỜI TIẾT TẠI ${city.toUpperCase()}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Nhiệt độ: ${weatherData!['currentConditions']['temp'].round()}°C',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          'Trạng Thái: ${weatherData!['currentConditions']['conditions'].toString()}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Enter a city to get weather data.',
                      style: TextStyle(color: Colors.white),
                    ),
                  _buildWeatherImage(),
                ],
              ),
              
                Column(
                  children: [
                    _buildWeatherDetails(),
                    SizedBox(height: 20),
                    _build7DayForecast(), // Thêm phần dự báo 7 ngày
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
