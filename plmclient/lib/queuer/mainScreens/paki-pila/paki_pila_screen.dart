import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/bike_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/home_screen.dart';
import 'package:plmclient/queuer/mainScreens/paki-pila/paki_pila_directions_detail.dart';

import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/models/booking_details.dart';

import '../../../main.dart';
import '../homescreen/walker_homescreen.dart';


class PakiPilaScreen extends StatefulWidget
{
  @override
  _PakiPilaScreenState createState() => _PakiPilaScreenState();
}

class _PakiPilaScreenState extends State<PakiPilaScreen>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title: const Text(
            "Paki-Pila Bayad Bookings",
            style: TextStyle(fontSize: 35.0, letterSpacing: 3, color: Colors.white, fontFamily: "Signatra"),
          ),
          leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                  onPressed: (){
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
                  icon: Icon(Icons.arrow_back)
              );
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection("booking")
              .where("serviceType", isEqualTo: "paki-pila")
              .where("status", isEqualTo: "normal")
              .where("zone", isEqualTo: zone)
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView(
              children: snapshot.data!.docs.map((document){
                return InkWell(
                  onTap: ()
                  {
                    BookingDetails bookingDetails =  BookingDetails();
                    bookingDetails.bookID = document['bookID'];
                    bookingDetails.clientUID = document['clientUID'];
                    bookingDetails.dropoffaddress = document['dropoffaddress'];
                    bookingDetails.dropoffaddresslat = document['dropoffaddressLat'];
                    bookingDetails.dropoffaddresslng = document['dropoffaddressLng'];
                    bookingDetails.pickupaddress = document['pickupaddress'];
                    bookingDetails.pickupaddresslat = document['pickupaddressLat'];
                    bookingDetails.pickupaddresslng = document['pickupaddressLng'];
                    bookingDetails.notes = document['notes'];
                    bookingDetails.phoneNum = document['phoneNum'];
                    bookingDetails.orderTime = document['orderTime'];
                    bookingDetails.serviceType = document['serviceType'];
                    bookingDetails.status = document['status'];

                    Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiPilaDirectionScreen(bookingDetails: bookingDetails,)));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black12,
                            Colors.white54,
                          ],
                          begin:  FractionalOffset(0.0, 0.0),
                          end:  FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        )
                    ),
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TransactionID: "+ document['bookID']),
                            Divider(thickness: 2,),
                            Text("Service: "+ document['serviceType']),
                            Divider(thickness: 2,),
                            Text("Notes: "+ document['notes']),
                            Divider(thickness: 2,),
                            Text("PickUp Address: "+ document['pickupaddress']),
                            Divider(thickness: 2,),
                            Text("DropOff Address: "+ document['dropoffaddress']),
                            Divider(thickness: 2,),
                            Text("Phone Number: "+ document['phoneNum']),
                            Divider(thickness: 2,),
                            Text("Price: P"+ document['price'].toString()),
                            Divider(thickness: 2,),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
                : const Center(child: Text("No Orders yet"),);
          },
        ),
      ),
    );
  }
}
