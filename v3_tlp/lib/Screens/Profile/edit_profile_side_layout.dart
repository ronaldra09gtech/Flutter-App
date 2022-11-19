import 'package:flutter/material.dart';
import '../../Splash Screen/sidebar.dart';
import 'edit_profile.dart';

class SideBarLayoutEditProfile extends StatelessWidget {
  const SideBarLayoutEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: const <Widget>[
            EditProfile(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}