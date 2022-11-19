import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Transfer%20Load/transfer_load_body.dart';
import 'package:v3_tlp/Splash%20Screen/sidebar.dart';


class TranferLoad extends StatefulWidget {
  String? queueremail;

  TranferLoad({super.key, this.queueremail});

  @override
  State<TranferLoad> createState() => _TranferLoadState();
}

class _TranferLoadState extends State<TranferLoad> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            TransferLoadBody(queueremail: widget.queueremail),
            const SideBar(),
          ],
        ),
      ),
    );
  }
}
