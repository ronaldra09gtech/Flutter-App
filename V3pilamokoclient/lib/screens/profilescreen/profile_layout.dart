import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/profilescreen/profile.dart';
import '../../splash screen/botbar.dart';

class SideBarLayoutProfile extends StatelessWidget {
  const SideBarLayoutProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            const Profile(),
            BotBar(),
          ],
        ),
      ),
    );
  }
}