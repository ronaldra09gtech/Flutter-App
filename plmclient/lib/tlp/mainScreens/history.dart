
import 'package:flutter/material.dart';
import 'package:plmclient/tlp/mainScreens/transfer_history.dart';

import 'debit_history.dart';

class TransferLoadHistoryScreen extends StatefulWidget {
  const TransferLoadHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransferLoadHistoryScreenState createState() => _TransferLoadHistoryScreenState();

}

class _TransferLoadHistoryScreenState extends State<TransferLoadHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.lightBlueAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: const FittedBox(
            child: Text(
              "Transfer Load History",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontFamily: "Lobster",
              ),
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Transfer Load",
              ),
              Tab(
                text: "Debit",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
              )
          ),
          child: const TabBarView(
            children: [
              TransferHistory(),
              DebitHistory(),
            ],
          ),
        ),
      ),
    );
  }
}
