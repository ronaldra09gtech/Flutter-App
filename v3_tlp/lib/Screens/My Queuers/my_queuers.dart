import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/My%20Queuers/my_queuers_layout.dart';

import '../../Splash Screen/sidebar.dart';


class MyQueuers extends StatefulWidget {
  const MyQueuers({Key? key}) : super(key: key);

  @override
  State<MyQueuers> createState() => _MyQueuersState();
}

class _MyQueuersState extends State<MyQueuers> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: const <Widget>[
            MyQueuersLayOut(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
