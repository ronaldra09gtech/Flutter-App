import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Transfer%20Load/queuer_transfer_load_body.dart';
import 'package:v3_tlp/Splash%20Screen/sidebar.dart';


class QueuerTransferLoad extends StatefulWidget {
  const QueuerTransferLoad({Key? key}) : super(key: key);

  @override
  State<QueuerTransferLoad> createState() => _QueuerTransferLoadState();
}

class _QueuerTransferLoadState extends State<QueuerTransferLoad> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: const <Widget>[
            QueuerTransferLoadBody(),
            SideBar(),
          ],
        ),
      ),
    );
  }
}
