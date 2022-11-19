
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/home_Screen.dart';
import 'package:plmclient/client/mainScreens/pakiproxy/paki_proxy_address_screen.dart';

class PakiProxyScreen extends StatefulWidget {
  const PakiProxyScreen({Key? key}) : super(key: key);

  @override
  State<PakiProxyScreen> createState() => _PakiProxyScreenState();
}

class _PakiProxyScreenState extends State<PakiProxyScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
          title: const Text(
            "PILAMOKO",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
          leading: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
              },
              child: Icon(Icons.arrow_back)
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("facilities")
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView(
              children: snapshot.data!.docs.map((document){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => PakiProxyAddress(name: document['name'].toString(),)));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              blurRadius: 5,
                              offset: Offset(0,5)
                          ),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-5,0)
                          ),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(5,0)
                          )
                        ]
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: Text(document['name'], style: TextStyle(fontSize: 30),),
                  ),
                );
              }).toList(),
            )
                : Container();
          },
        )
      ),
    );
  }
}
