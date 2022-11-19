import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../global/global.dart';
import 'home_Screen.dart';

class PickQueuer extends StatefulWidget {
  const PickQueuer({Key? key}) : super(key: key);

  @override
  State<PickQueuer> createState() => _PickQueuerState();
}

class _PickQueuerState extends State<PickQueuer> {
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
          "Pick your Queuer",
          style: const TextStyle(fontSize: 45.0, letterSpacing: 3, color: Colors.white, fontFamily: "Signatra"),
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot> (
        stream: FirebaseFirestore.instance
            .collection("pilamokoqueuer")
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
                      .collection("pilamokoclient")
                      .doc(sharedPreferences!.getString("email"))
                      .update({
                    "queuer":document['pilamokoqueuerEmail'],
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection("queuerClientList")
                        .doc(document['pilamokoqueuerEmail'])
                        .collection("Clients")
                        .doc(sharedPreferences!.getString("email").toString())
                        .set({
                      "pilamokoclientName":sharedPreferences!.getString("name"),
                      "pilamokoclientEmail":sharedPreferences!.getString("email"),
                      "phone":phoneNumber,
                    });
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.black12
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Text("Queuer Name: "+ document['pilamokoqueuerName'], style: TextStyle(fontSize: 20)),
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
