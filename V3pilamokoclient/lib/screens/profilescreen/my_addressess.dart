import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/profilescreen/add_new_adress.dart';
import 'package:v3pilamokoemall/screens/profilescreen/edit_address.dart';

import '../../global/global.dart';

class MyAddressess extends StatefulWidget {
  String? addressID;
  MyAddressess({this.addressID});
  @override
  State<MyAddressess> createState() => _MyAddressessState();
}

class _MyAddressessState extends State<MyAddressess> {

  setDeliveryAddress(String addressID)async{

    await FirebaseFirestore.instance.collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email")!).collection("myDeliveryAddresses")
        .doc(widget.addressID).update({
      "status": 'Not in use'
    }).whenComplete(() async {
      await FirebaseFirestore.instance.collection("pilamokoclient")
          .doc(sharedPreferences!.getString("email")!).collection("myDeliveryAddresses")
          .doc(addressID).update({
        "status": 'In use'
      }).whenComplete((){
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Address",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("pilamokoclient")
                .doc(sharedPreferences!.getString("email")!)
                .collection("myDeliveryAddresses")
                .snapshots(),
            builder: (c, snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.size > 0){
                  return Column(
                    children: snapshot.data!.docs.map((document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){
                            setDeliveryAddress(document.id);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Stack(
                              children: [
                                Icon(Icons.location_on, color:  document['status'] == 'In use' ? Colors.red : Colors.blue),
                                Positioned(
                                  left: 35,
                                  top: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Delivery Address",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        document['name'] + " | " + document['phone'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300
                                        ),
                                      ),
                                      Text(
                                        document['address'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 1,
                                  right: 1,
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (c)=> EditAddress()));
                                    },
                                      child: Text("Edit",style: TextStyle(fontSize: 18),)
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                else {
                  return Container(child: Text("You have no address yet"),);
                }
              }
              else {
                return Center(child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 12),
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      Colors.blue,
                    ),
                  ),
                ),);
              }

            },
          ),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width /3),
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> AddNewAddress()));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline),
                  SizedBox(width: 5,),
                  Text("Add New Address",style: TextStyle(fontSize: 15),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
