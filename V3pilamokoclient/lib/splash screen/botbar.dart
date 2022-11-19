import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/add_to_cart_screen/add_cart_screen.dart';
import 'package:v3pilamokoemall/screens/cartscreen/carthome.dart';
import 'package:v3pilamokoemall/screens/homescreen/homepage.dart';
import 'package:v3pilamokoemall/screens/services/services.dart';

import '../screens/services/docu_assistance.dart';
import '../screens/profilescreen/profile.dart';

class BotBar extends StatefulWidget {
  int? page;
  BotBar({this.page});

  @override
  State<BotBar> createState() => _BotBarState();
}

class _BotBarState extends State<BotBar> {

  int _currtentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currtentIndex = widget.page!;
  }

  final tabs = [
    Center(child: Profile()),
    Center(child: HomePage()),
    Center(child: CartHomeScreen()),
    Center(child: AddCartScreen()),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currtentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currtentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 15,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            activeIcon: Icon(Icons.person_outline),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              activeIcon: Icon(Icons.home_outlined)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: "Orders",
            activeIcon: Icon(Icons.delivery_dining_outlined)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
              activeIcon: Icon(Icons.shopping_cart_checkout_outlined)
          ),
        ],
        onTap: (index) {
          setState(() {
            _currtentIndex = index;
          });
        },
      ),
    );
  }
}
