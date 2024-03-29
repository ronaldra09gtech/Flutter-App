import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/assistantMethods/get_current_location.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/emall/emall_direction_details.dart';
import 'package:plmclient/queuer/mainScreens/emall/emall_order_screen.dart';
import 'package:plmclient/queuer/mainScreens/eresto/parcel_picking_screen.dart';
import 'package:plmclient/queuer/models/address.dart';
import 'package:plmclient/queuer/splashScreen/splashScreen.dart';

import '../../client/widgets/error_dialog.dart';
import '../../main.dart';


double? sellerLat;
double? sellerLng;
String? phonenum;
String? clientID;

class ShipmentAddressDesign extends StatelessWidget
{
  final Address? model;
  final String? orderStatus;
  final String? orderID;
  final String? sellerID;
  final String? orderByUser;

  ShipmentAddressDesign({this.model, this.orderStatus, this.orderID, this.sellerID, this.orderByUser});


  confirmedParcelShipment(BuildContext context, String getOrderID, String sellerID, String purchaserID)
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(getOrderID)
        .get()
        .then((snapshot){
          if(snapshot.data()!["riderUID"].toString().isEmpty){
            FirebaseFirestore.instance
                .collection("orders")
                .doc(getOrderID)
                .update({
              "riderUID": sharedPreferences!.getString("uid"),
              "riderName": sharedPreferences!.getString("name"),
              "status": "picking",
              "lat": position!.latitude,
              "lng": position!.longitude,
              "address": completeAddress,
            }).then((value) {
              FirebaseFirestore.instance
                  .collection("pilamokoemall")
                  .doc(sellerID)
                  .get()
                  .then((DocumentSnapshot)
              {
                sellerLat = DocumentSnapshot.data()!["lat"];
                sellerLng = DocumentSnapshot.data()!["lng"];
                phonenum = DocumentSnapshot.data()!["phone"];
                clientID = DocumentSnapshot.data()!["orderBy"];
              });
            }).whenComplete((){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EmallDirectionDetails(
                orderID: getOrderID,
                purchaserlat: model!.lat,
                purchaserlng: model!.lng,
                sellerID: sellerID,
                sellerLat: sellerLat,
                sellerLng: sellerLng,
                phonenum: phonenum,
              )));
            });
          }
          else {
            if(snapshot.data()!["riderUID"].toString() == sharedPreferences!.getString("email")){
              FirebaseFirestore.instance
                  .collection("orders")
                  .doc(getOrderID)
                  .update({
                "riderUID": sharedPreferences!.getString("uid"),
                "riderName": sharedPreferences!.getString("name"),
                "status": "picking",
                "lat": position!.latitude,
                "lng": position!.longitude,
                "address": completeAddress,
              }).then((value) {
                FirebaseFirestore.instance
                    .collection("pilamokoemall")
                    .doc(sellerID)
                    .get()
                    .then((DocumentSnapshot)
                {
                  sellerLat = DocumentSnapshot.data()!["lat"];
                  sellerLng = DocumentSnapshot.data()!["lng"];
                  phonenum = DocumentSnapshot.data()!["phone"];
                });
              }).whenComplete((){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> EmallDirectionDetails(
                  orderID: getOrderID,
                  purchaserlat: model!.lat,
                  purchaserlng: model!.lng,
                  sellerID: sellerID,
                  sellerLat: sellerLat,
                  sellerLng: sellerLng,
                  phonenum: phonenum,
                )));
              });
            }
            else {
              showDialog(
                  context: context,
                  builder: (c)
                  {
                    return AlertDialog(
                      key: key,
                      content: Text("This order is taken by another Queuer"),
                      actions: [
                        ElevatedButton(
                          child: const Center(
                            child: Text("OK"),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: ()
                          {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> EmallOrderScreen()));
                          },
                        ),
                      ],
                    );
                  }
              );
            }
          }
        });



    //send rider to shipment screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ParcelPickingScreen(
    //   purchaserID: purchaserID,
    //   purchaserAddress: model!.fullAddress,
    //   purchaserLat: model!.lat,
    //   purchaserLng: model!.lng,
    //   sellerID: sellerID,
    //   getOrderID: getOrderID,
    //
    // )));



  }

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              'Shipping Details:',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),


        orderStatus == "ended"
            ? Container()
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                UserLocation uLocation = UserLocation();
                uLocation.getCurrentLocation();

                confirmedParcelShipment(context, orderID!, sellerID!, orderByUser!);
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
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Confirm - To Deliver this Parcel",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreenQueuer()));
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
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20,),
      ],
    );
  }
}
