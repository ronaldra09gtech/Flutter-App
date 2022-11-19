import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/bike_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/home_screen.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/walker_homescreen.dart';

import '../../main.dart';

class PickTLPScreen extends StatefulWidget {
  const PickTLPScreen({Key? key}) : super(key: key);

  @override
  State<PickTLPScreen> createState() => _PickTLPScreenState();
}

class _PickTLPScreenState extends State<PickTLPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Colors.lightBlue,
                  Colors.blueAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Pick your TLP",
          style: const TextStyle(fontSize: 45.0, letterSpacing: 3, color: Colors.white, fontFamily: "Signatra"),
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot> (
        stream: FirebaseFirestore.instance
            .collection("pilamokotlp")
            .where("zone", isEqualTo: zone)
            .snapshots(),
        builder: (c, snapshot)
        {
          return snapshot.hasData
              ? ListView(
            children: snapshot.data!.docs.map((document){
              return InkWell(
                onTap: ()
                {
                  FirebaseFirestore.instance
                      .collection("pilamokoqueuer")
                      .doc(sharedPreferences!.getString("email"))
                      .update({
                    "tlp":document['pilamokotlpUID'],
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection("tlpQueuerList")
                        .doc(document['pilamokotlpUID'])
                        .set({
                      "pilamokoqueuerName":sharedPreferences!.getString("name"),
                      "pilamokoqueuerEmail":sharedPreferences!.getString("email"),
                      "phone":phone,
                      "loadwallet":load,
                    });
                  });
                  if(sharedPreferences!.getString("queuerType")!.toString() == "Walking Queuer"){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerHomeScreen()));
                  }
                  else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Bike / Bike"){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> BikerHomeScreen()));
                  }
                  else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Motorcycle" || sharedPreferences!.getString("queuerType")!.toString() == "Queuer with 4 Wheels"){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black12
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Text("TLP Name: "+ document['pilamokotlpName'], style: TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
          )
              : const Center(child: Text("No Orders yet",),);
        },
      ),
    );
  }
}
