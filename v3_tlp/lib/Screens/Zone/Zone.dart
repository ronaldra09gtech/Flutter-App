import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Zone/zone_body.dart';

import '../../Splash Screen/sidebar.dart';

class ZoneLayout extends StatefulWidget {
  const ZoneLayout({Key? key}) : super(key: key);

  @override
  State<ZoneLayout> createState() => _ZoneLayoutState();
}

class _ZoneLayoutState extends State<ZoneLayout> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: const <Widget>[
            ZoneBody(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
