import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/assistantMethods/get_current_location.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/eresto/parcel_delivering_screen.dart';
import 'package:plmclient/queuer/maps/map_utils.dart';

class ParcelPickingScreen extends StatefulWidget
{
  String? purchaserID;
  String? sellerID;
  String? getOrderID;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;

  ParcelPickingScreen({
    this.purchaserID,
    this.sellerID,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  _ParcelPickingScreenState createState() => _ParcelPickingScreenState();
}



class _ParcelPickingScreenState extends State<ParcelPickingScreen>
{
  double? sellerLat, sellerLng;
  String? serviceType;
  getSellerData() async
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.getOrderID)
        .get()
        .then((snapshot)
    {
      serviceType = snapshot.data()!["serviceType"];
    }).then((value) {
      if(serviceType =="eresto"){
        FirebaseFirestore.instance
            .collection("pilamokoseller")
            .doc(widget.sellerID)
            .get()
            .then((DocumentSnapshot)
        {
          sellerLat = DocumentSnapshot.data()!["lat"];
          sellerLng = DocumentSnapshot.data()!["lng"];
        });
      }
      else if(serviceType =="emall"){
        FirebaseFirestore.instance
            .collection("pilamokoemall")
            .doc(widget.sellerID)
            .get()
            .then((DocumentSnapshot)
        {
          sellerLat = DocumentSnapshot.data()!["lat"];
          sellerLng = DocumentSnapshot.data()!["lng"];
        });
      }
      else if(serviceType =="emarket"){
        FirebaseFirestore.instance
            .collection("pilamokoemarket")
            .doc(widget.sellerID)
            .get()
            .then((DocumentSnapshot)
        {
          sellerLat = DocumentSnapshot.data()!["lat"];
          sellerLng = DocumentSnapshot.data()!["lng"];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

    getSellerData();
  }

  confirmParcelHasBeenPicked(getOrderID, sellerID, purchaserID, purchaserAddress, purchaserLat, purchaserLng)
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderID).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelDeliveringScreen(
      purchaserID: purchaserID,
      purchaserAddress: purchaserAddress,
      purchaserLat: purchaserLat,
      purchaserLng: purchaserLng,
      sellerID: sellerID,
      getOrderID: getOrderID,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.asset(
            "images/confirm1.png",
            width: 350,
          ),
          const SizedBox(height: 5,),

          GestureDetector(
            onTap: ()
            {
              //show location from rider current location towards seller location
              MapUtils.launchMapFromSourceToDestination(position!.latitude, position!.longitude, sellerLat, sellerLng);
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
                      "Show Cafe/Restaurant Location",
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
                  confirmParcelHasBeenPicked(
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
                      "Order has been Picked - Confirmed",
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
