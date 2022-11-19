import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/assistantMethods/get_current_location.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/maps/map_utils.dart';
import 'package:plmclient/queuer/splashScreen/splashScreen.dart';

import '../../../main.dart';

class ParcelDeliveringScreen extends StatefulWidget {

  String? purchaserID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerID;
  String? getOrderID;

  ParcelDeliveringScreen({
    this.getOrderID,
    this.sellerID,
    this.purchaserLng,
    this.purchaserLat,
    this.purchaserAddress,
    this.purchaserID
  });
  @override
  _ParcelDeliveringScreenState createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {

  String orderTotalAmount = "";
  String serviceType ="";
  confirmParcelHasBeenDelivered(getOrderID, sellerID, purchaserID, purchaserAddress, purchaserLat, purchaserLng)
  {
    String riderNewTotalEarningAmount = ((double.parse(previousRiderEarnings)) + (double.parse(perParcelDeliveryAmount))).toString();

    FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderID)
        .update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earning": perParcelDeliveryAmount,
    }).then((value){
      FirebaseFirestore.instance
          .collection("pilamokoqueuer")
          .doc(sharedPreferences!.getString("email"))
          .update({
        "earning":riderNewTotalEarningAmount,
      });
    }).then((value){
      if(serviceType == "eresto"){
        FirebaseFirestore.instance
            .collection("pilamokoseller")
            .doc(widget.sellerID)
            .update({
          "earning":(double.parse(orderTotalAmount) + (double.parse(previousEarnings))).toString(), //total earnings amount of seller,
        });
      }
      else if(serviceType == "emall"){
        FirebaseFirestore.instance
            .collection("pilamokoemall")
            .doc(widget.sellerID)
            .update({
          "earning":(double.parse(orderTotalAmount) + (double.parse(previousEarnings))).toString(), //total earnings amount of seller,
        });
      }

      else if(serviceType == "emarket"){
        FirebaseFirestore.instance
            .collection("pilamokoemarket")
            .doc(widget.sellerID)
            .update({
          "earning":(double.parse(orderTotalAmount) + (double.parse(previousEarnings))).toString(), //total earnings amount of seller,
        });
      }

    }).then((value){
      FirebaseFirestore.instance
          .collection("pilamokoclient")
          .doc(purchaserID)
          .collection("orders")
          .doc(getOrderID).update(
          {
            "status": "ended",
            "riderUID": sharedPreferences!.getString("uid"),
          });
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreenQueuer()));
  }

  getOrderTotalAmount()
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderID)
        .get()
        .then((snap){
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerID = snap.data()!["sellerUID"].toString();
      serviceType = snap.data()!["serviceType"].toString();
    }).then((value){
      if(serviceType == "eresto"){
        getSellerData();
      }
      else if(serviceType == "emall") {
        getEmallData();
      }
      else if(serviceType == "emarket") {
        getEmarketData();
      }
    });
  }

  getSellerData()
  {
    FirebaseFirestore.instance
        .collection("pilamokoseller")
        .doc(widget.sellerID)
        .get().then((snap){
      previousEarnings = snap.data()!["earning"].toString();
    });
  }

  getEmallData()
  {
    FirebaseFirestore.instance
        .collection("pilamokoemall")
        .doc(widget.sellerID)
        .get().then((snap){
      previousEarnings = snap.data()!["earning"].toString();
    });
  }

  getEmarketData()
  {
    FirebaseFirestore.instance
        .collection("pilamokoemarket")
        .doc(widget.sellerID)
        .get().then((snap){
      previousEarnings = snap.data()!["earning"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.asset(
            "images/confirm2.png",
          ),
          const SizedBox(height: 5,),

          GestureDetector(
            onTap: ()
            {
              //show location from rider current location towards seller location
              MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, widget.purchaserLat, widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'images/restaurant.png',
                  width: 50,
                ),

                const SizedBox(height: 7,),

                Column(
                  children: const [
                    SizedBox(height: 13,),
                    Text(
                      "Show Delivery Drop-off Location",
                      style: TextStyle(
                        fontFamily: "Lobster",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),

          const SizedBox(height: 35,),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: ()
                {
                  //confirm that rider has picked parcel from restaurant
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();
                  confirmParcelHasBeenDelivered(
                      widget.getOrderID,
                      widget.sellerID,
                      widget.purchaserID,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng
                  );
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreen()));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.blue,
                        ],
                        begin:  FractionalOffset(0.0, 0.0),
                        end:  FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      )
                  ),
                  width: MediaQuery.of(context).size.width - 100,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been delivered - Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),

        ],

      ),

    );
  }
}
