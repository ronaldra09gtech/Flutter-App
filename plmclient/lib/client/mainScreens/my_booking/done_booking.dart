import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../global/global.dart';

class DoneBooking extends StatefulWidget {
  const DoneBooking({Key? key}) : super(key: key);

  @override
  State<DoneBooking> createState() => _DoneBookingState();
}

class _DoneBookingState extends State<DoneBooking> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection("booking")
              .where("clientUID", isEqualTo: sharedPreferences!.getString("email"))
              .where("status", isEqualTo: "ended")
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView(
              children: snapshot.data!.docs.map((document){
                return Container(
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
                  margin: const EdgeInsets.all(10),
                  child: document["serviceType"] != "paki-proxy"
                      ? Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text("TransactionID: "+ document['bookID']),
                          Divider(thickness: 2,),
                          Text("Name: "+ sharedPreferences!.getString("name")!),
                          Divider(thickness: 2,),
                          Text("Pick-up Location: "+ document['pickupaddress']),
                          Divider(thickness: 2,),
                          Text("Drop-off location: "+ document['dropoffaddress']),
                          Divider(thickness: 2,),
                          Text("What Item: "+ document['notes']),
                          Divider(thickness: 2,),
                          Text("Payment Method: "+ document['paymentMethods']),
                          Divider(thickness: 2,),
                          Text("Price: ₱"+ document['price'].toString()),
                          Divider(thickness: 2,),
                          Text("Status: "+ document['status'].toString()),
                          Divider(thickness: 2,),
                        ],
                      ),
                    ),
                  )
                      : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text("TransactionID: "+ document['bookID']),
                          Divider(thickness: 2,),
                          Text("Name: "+ sharedPreferences!.getString("name")!),
                          Divider(thickness: 2,),
                          Text("Pick-up Location: "+ document['pickupaddress']),
                          Divider(thickness: 2,),
                          Text("What Item: "+ document['notes']),
                          Divider(thickness: 2,),
                          Text("Payment Method: "+ document['paymentMethods']),
                          Divider(thickness: 2,),
                          Text("Price: ₱"+ document['price'].toString()),
                          Divider(thickness: 2,),
                          Text("Status: "+ document['status'].toString()),
                          Divider(thickness: 2,),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
                : const Center(child: Text("No Done Bookings yet"),);
          },
        ),
      ),
    );
  }
}
