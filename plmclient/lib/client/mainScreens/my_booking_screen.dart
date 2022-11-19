import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/my_booking/done_booking.dart';
import 'package:plmclient/client/mainScreens/my_booking/pending_booking.dart';
import 'package:plmclient/client/mainScreens/my_booking/ongoing_booking.dart';
import 'package:plmclient/client/widgets/my_drawer.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            "My Booking",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Lobster",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.document_scanner_outlined, color: Colors.white,),
                text: "Pending",
              ),
              Tab(
                icon: Icon(Icons.document_scanner_outlined, color: Colors.white,),
                text: "Ongoing",
              ),
              Tab(
                icon: Icon(Icons.document_scanner_outlined, color: Colors.white,),
                text: "Done",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        drawer: MyDrawer(),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
              )
          ),
          child: TabBarView(
            children: [
              PendingBooking(),
              OngoingBooking(),
              DoneBooking(),
            ],
          ),
        ),
      ),
    );
  }
}
