import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/pakiproxy/paki_proxy_schedule.dart';
import 'package:plmclient/client/models/place_predictions.dart';

class PakiProxyAddress extends StatefulWidget {
  String? name;

  PakiProxyAddress({this.name});
  @override
  State<PakiProxyAddress> createState() => _PakiProxyAddressState();
}



class _PakiProxyAddressState extends State<PakiProxyAddress> {
  List<PlacePrediction> placePredictionList= [];

  double? pickUpAddressLat;
  double? pickUpAddressLng;
  String? pickupplaceID;

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
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("facilities")
              .doc(widget.name!)
              .collection("branches")
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView(
              children: snapshot.data!.docs.map((document){
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiProxySchedule(address: document['address'],name: widget.name,schedule: document['schedule'],)));
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
                    child: Text(document['address'], style: TextStyle(fontSize: 14),),
                  ),
                );
              }).toList(),
            )
                : Container();
          },
        ),
      ),
    );
  }
}
