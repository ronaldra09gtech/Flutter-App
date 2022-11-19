import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Request%20Load/request_load_body.dart';

import '../../Splash Screen/sidebar.dart';


class RequestLoad extends StatefulWidget {
  const RequestLoad({Key? key}) : super(key: key);

  @override
  State<RequestLoad> createState() => _RequestLoadState();
}

class _RequestLoadState extends State<RequestLoad> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: const <Widget>[
            RequestLoadBody(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
