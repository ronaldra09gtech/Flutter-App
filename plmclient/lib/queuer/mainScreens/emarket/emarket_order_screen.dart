import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/emarket/emarket_new_order_screen.dart';
import 'package:plmclient/queuer/mainScreens/eresto/not_yet_delivered_screen.dart';
import 'package:plmclient/queuer/mainScreens/eresto/parcel_in_progress_screen.dart';

class EmarketOrderScreen extends StatefulWidget {
  const EmarketOrderScreen({Key? key}) : super(key: key);

  @override
  _EmarketOrderScreenState createState() => _EmarketOrderScreenState();
}

class _EmarketOrderScreenState extends State<EmarketOrderScreen> {
  int currentIndex = 0;
  final screens = [
    EmarketNewOrdersScreen(),
    ParcelInProgressScreen(),
    NotYetDeliveredScreen(),
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
              label: 'New Available Orders',
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle),
              label: 'Parcels in Progress',
              backgroundColor: Colors.lightBlue),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_history),
              label: 'Not Yet Delivered',
              backgroundColor: Colors.lightBlue),
        ],
      ),
    );
  }
}
