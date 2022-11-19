import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/authentication/authScreen.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/emall/e_mall_screen.dart';
import 'package:plmclient/client/mainScreens/emarket/e_market_screen.dart';
import 'package:plmclient/client/mainScreens/pakidala/paki_dala_screen.dart';
import 'package:plmclient/client/mainScreens/eresto/e_resto_screen.dart';
import 'package:plmclient/client/mainScreens/pakipila/paki_pila_screen.dart';
import 'package:plmclient/client/mainScreens/pakiproxy/paki_proxy_screen.dart';
import 'package:plmclient/client/widgets/my_drawer.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  getClientData() async
  {
    await FirebaseFirestore.instance
        .collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email"))
        .get()
        .then((snap){
      setState(() {
        email = snap.data()!['email'].toString();
        address = snap.data()!['address'].toString();
        zone = snap.data()!['zone'].toString();
        phoneNumber = snap.data()!['phone'].toString();
        loadWallet = snap.data()!['loadWallet'].toString();
        queuer = snap.data()!['queuer'].toString();
        phone = snap.data()!['phone'].toString();
      });

    }).then((value){
      FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("paki-dala")
          .get()
          .then((snapshot){
        setState(() {
          pakiDalaPerKMfee = snapshot.data()!['PerKMFee'].toString();
          pakiDalaPlugRate = snapshot.data()!['PlugRate'].toString();
          pakiDalaBaseFee = snapshot.data()!['basefee'].toString();
        });
      });
    }).then((value){
      FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("paki-pila")
          .get()
          .then((snapshot){
        setState(() {
          pakiPilaPerHour = snapshot.data()!['perhour'].toString();
          pakiPilaBasefee = snapshot.data()!['baseFee'].toString();
        });
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("paki-proxy")
          .get()
          .then((snapshot){
        setState(() {
          pakiProxyBaseFee = double.parse(snapshot.data()!['baseFee'].toString());
        });

      });
    });
  }

  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 15,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
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
        )
            : const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.lightBlueAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: InkWell(
          onTap:() {
            if(index == 0)
            {
              //pakipila
              Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiPilaScreen()));
            }
            if(index == 1)
            {
              //pakidala
              Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiDalaScreen()));
            }
            if(index == 2)
            {
              //pakiproxy
              Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiProxyScreen()));
            }
            if(index == 3)
            {
              //Emall
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EMallScreen()));
            }
            if(index == 4)
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ERESTOScreen()));
              //Eresto
            }
            if(index == 5)
            {
              //Emarket
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EMarketScreen()));
            }
            if(index == 6)
            {
              Fluttertoast.showToast(msg: "This Service is not Available.");
              //Document
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Icon(
                    iconData,
                    size: 90,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool connected=true;
  String status = "Unknown";
  final _connectivity = Connectivity();
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    initialisedConnectivity();
    super.initState();

    getClientData();
    clearCartNow(context);
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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.lightBlueAccent,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      
      body: DoubleBack(
        message: "Double Back Press to exit",
        background: Colors.red,
        backgroundRadius: 10,

        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("Paki Pila Bayad", Icons.people_alt_outlined, 0),
            makeDashboardItem("Paki Dala", Icons.delivery_dining_outlined, 1),
            makeDashboardItem("Paki Pila Proxy", Icons.file_copy, 2),
            makeDashboardItem("PLM E-Mall", Icons.home_work_rounded, 3),
            makeDashboardItem("PLM E-Restaurant", Icons.food_bank_outlined, 4),
            makeDashboardItem("PLM E-Market", Icons.home_work_sharp, 5),
            makeDashboardItem("Document", Icons.file_copy, 6),
          ],
        ),
      ),
    );
  }
}
