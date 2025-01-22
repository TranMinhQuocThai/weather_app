import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_app/widget/weather_screen.dart' as weather_screen;
import 'package:weather_app/widget/ortherlocation.dart' as ortherlocation;
void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    weather_screen.weather(),
    ortherlocation.WeatherDisplay(),  // Add your other location widget here.
 ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sunny),
            label: 'Thời tiết',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            label: 'Khu vực khác',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow underneath the bottom navigation bar.
        onTap: _onItemTapped,
      ),);}}