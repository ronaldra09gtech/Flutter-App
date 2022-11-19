import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../global/global.dart';
import '../widgets/my_drawer.dart';
import '../authentication/authScreen.dart';

class HomeScreenTLP extends StatefulWidget {
  const HomeScreenTLP({Key? key}) : super(key: key);

  @override
  _HomeScreenTLPState createState() => _HomeScreenTLPState();

}

class _HomeScreenTLPState extends State<HomeScreenTLP> {
  getTlpData()
  {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap){
          setState(() {
            email = snap.data()!['pilamokotlpEmail'].toString();
            phone = snap.data()!['phone'].toString();
            address = snap.data()!['address'].toString();
            zone = snap.data()!['zone'].toString();
            //number = snap.data()!['earning'].toString();
            date = snap.data()!['date'].toString();
            loadWallet = snap.data()!['loadWallet'].toString();
          });
    });
  }

  bool connected=true;
  String status = "Unknown";
  final _connectivity = Connectivity();
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  StreamSubscription<ConnectivityResult>? _streamSubscription;

  @override
  void initState() {
    initialisedConnectivity();
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {updateConnectivityStatus(event);
    });
    super.initState();
    getTlpData();
  }

  initialisedConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    result = await _connectivity.checkConnectivity();
    updateConnectivityStatus(result);
    print(result);
  }

  updateConnectivityStatus(ConnectivityResult result){
    connectivityResult = result;
    switch(result){
      case ConnectivityResult.none:
        status = "Not Connected";
        setState(() {
          connected=false;
        });

        break;
      case ConnectivityResult.wifi:
        status = "Connected to Wifi";
        setState(() {
          connected=true;
        });
        break;
      case ConnectivityResult.mobile:
        status = "Connected to Mobile Data";
        setState(() {
          connected=true;
        });
        break;
      default:
    }

    if(!connected)
    {
      firebaseAuth.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (c)=> AuthScreen()));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: DoubleBack(
        message: "Double Back Press to exit",
        background: Colors.red,
        backgroundRadius: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            connectivityResult == ConnectivityResult.none ?
            Container(
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.red[400],
              alignment: Alignment.center,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Device is in offline",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ): Container(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                    color: Colors.black12
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text("Load Wallet", style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text("₱ " + loadWallet, style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
