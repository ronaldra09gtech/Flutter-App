import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/emall/emall_new_order_screen.dart';
import 'package:plmclient/queuer/mainScreens/eresto/eresto_new_orders_screen.dart';
import 'package:plmclient/queuer/mainScreens/eresto/not_yet_delivered_screen.dart';
import 'package:plmclient/queuer/mainScreens/eresto/parcel_in_progress_screen.dart';

class EmallOrderScreen extends StatefulWidget {
  const EmallOrderScreen({Key? key}) : super(key: key);

  @override
  _EmallOrderScreenState createState() => _EmallOrderScreenState();
}

class _EmallOrderScreenState extends State<EmallOrderScreen> {
  int currentIndex = 0;
  final screens = [
    EmallNewOrdersScreen(),
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
