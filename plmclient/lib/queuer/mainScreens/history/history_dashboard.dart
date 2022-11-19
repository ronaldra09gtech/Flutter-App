import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/history/booking_history.dart';
import 'package:plmclient/queuer/mainScreens/history/history_screen.dart';

class HistoryDashboard extends StatefulWidget {
  const HistoryDashboard({Key? key}) : super(key: key);

  @override
  _HistoryDashboardState createState() => _HistoryDashboardState();
}

class _HistoryDashboardState extends State<HistoryDashboard> {
  int currentIndex = 0;
  final screens = [
    HistoryScreen(),
    BookingHistory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        type: BottomNavigationBarType.shifting,
        currentIndex: currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: '',
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle),
              label: '',
              backgroundColor: Colors.lightBlue),
        ],
      ),
    );
  }
}
