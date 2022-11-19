import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/widgets/simple_app_bar.dart';

import '../../../main.dart';

class BookingHistory extends StatefulWidget {
  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: "Booking History",
        ),
        body: StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection("booking")
              .where("riderUID", isEqualTo: sharedPreferences!.getString("email"))
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
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text("TransactionID: "+ document['bookID']),
                          const SizedBox(height: 10,),
                          Text("Name: "+ sharedPreferences!.getString("name")!),
                          const SizedBox(height: 10,),
                          Text("Pick-up Location: "+ document['pickupaddress']),
                          const SizedBox(height: 10,),
                          Text("Drop-off location: "+ document['dropoffaddress']),
                          const SizedBox(height: 10,),
                          Text("What Item: "+ document['notes']),
                          const SizedBox(height: 10,),
                          Text("Payment Method: "+ document['paymentMethods']),
                          const SizedBox(height: 10,),
                          Text("Price: ₱"+ document['price'].toString()),
                          const SizedBox(height: 10,),
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
