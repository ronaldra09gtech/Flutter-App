import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Profile/profile.dart';
import '../../Splash Screen/sidebar.dart';

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
          children: const <Widget>[
            Profile(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}