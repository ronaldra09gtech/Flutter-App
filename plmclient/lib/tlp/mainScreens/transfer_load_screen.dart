import 'package:flutter/material.dart';
import 'package:plmclient/tlp/mainScreens/transfer_load_client.dart';
import 'package:plmclient/tlp/mainScreens/transfer_load_quer.dart';

import '../widgets/my_drawer.dart';

class TransferLoadScreen extends StatefulWidget {
  const TransferLoadScreen({Key? key}) : super(key: key);

  @override
  _TransferLoadScreenState createState() => _TransferLoadScreenState();

}

class _TransferLoadScreenState extends State<TransferLoadScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: MyDrawer(),
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
          title: const Text(
            "Transfer Load",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Lobster",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Client",
              ),
              Tab(
                text: "Queuer",
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
          child: const  TabBarView(
            children: [
              TransferLoadClient(),
              TransLoadQueuer(),
            ],
          ),
        ),
      ),
    );
  }
}
