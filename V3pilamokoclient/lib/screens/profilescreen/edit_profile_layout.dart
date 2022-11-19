import 'package:flutter/material.dart';
import '../../splash screen/botbar.dart';
import 'edit_profile.dart';


class SideBarLayoutEditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            const EditProfile(),
            BotBar(),
          ],
        ),
      ),
    );
  }
}