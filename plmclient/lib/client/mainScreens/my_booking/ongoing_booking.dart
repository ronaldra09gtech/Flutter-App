import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/assistantMethods/booking_details.dart';
import 'package:plmclient/client/mainScreens/track_queuer.dart';
import 'package:plmclient/client/global/global.dart';

import '../../../main.dart';

class OngoingBooking extends StatefulWidget {
  const OngoingBooking({Key? key}) : super(key: key);

  @override
  State<OngoingBooking> createState() => _OngoingBookingState();
}

class _OngoingBookingState extends State<OngoingBooking> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection("booking")
              .where("status", whereIn: ["delivering","picking"])
              .where("clientUID", isEqualTo: sharedPreferences!.getString("email"))
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
                    BookingDetails? bookingDetails =  BookingDetails();
                    bookingDetails.bookID = document['bookID'];
                    bookingDetails.clientUID = document['clientUID'];
                    bookingDetails.dropoffaddress = document['dropoffaddress'];
                    bookingDetails.dropoffaddresslat = document['dropoffaddressLat'];
                    bookingDetails.dropoffaddresslng = document['dropoffaddressLng'];
                    bookingDetails.pickupaddress = document['pickupaddress'];
                    bookingDetails.pickupaddresslat = document['pickupaddressLat'];
                    bookingDetails.pickupaddresslng = document['pickupaddressLng'];
                    bookingDetails.notes = document['notes'];
                    bookingDetails.price = document['price'].toString();
                    bookingDetails.phoneNum = document['phoneNum'];
                    bookingDetails.orderTime = document['orderTime'];
                    bookingDetails.serviceType = document['serviceType'];
                    bookingDetails.status = document['status'];
                    bookingDetails.paymentmethod = document['paymentMethods'];
                    bookingDetails.riderUID = document['riderUID'];

                    Navigator.push(context, MaterialPageRoute(builder: (c)=> TrackQueuer(bookingDetails: bookingDetails,)));
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
                  ),
                );
              }).toList(),
            )
                : const Center(child: Text("No Bookings yet"),);
          },
        ),
      ),
    );
  }
}
