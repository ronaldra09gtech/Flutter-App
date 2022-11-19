import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/homescreen/homepage.dart';
import '../../splash screen/botbar.dart';


class SideBarLayoutHome extends StatelessWidget {
  int? page;
  SideBarLayoutHome({this.page});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            HomePage(),
            BotBar(page: page,)
          ],
        ),
      ),
    );
  }
}