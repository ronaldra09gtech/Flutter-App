import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/splash%20screen/topbar.dart';

import '../../splash screen/botbar.dart';

class CartHomeScreen extends StatefulWidget {

  const CartHomeScreen({Key? key}) : super(key: key);

  @override
  State<CartHomeScreen> createState() => _CartHomeScreenState();
}

class _CartHomeScreenState extends State<CartHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            BotBar(page: 3),
            TopBar()
          ],
        ),
      ),
    );
  }
}
