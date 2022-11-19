import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/TLP%20Main%20Screen/tlp_mainscreen.dart';
import '../../Splash Screen/sidebar.dart';

class SideBarLayoutHome extends StatelessWidget {
  const SideBarLayoutHome({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: const <Widget>[
            HomePage(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}