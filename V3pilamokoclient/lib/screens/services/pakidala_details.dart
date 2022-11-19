import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v3pilamokoemall/widgets/loading_dialog.dart';

import '../../assistantMethods/assistant_methods.dart';
import '../../assistantMethods/direction_details.dart';
import '../../global/global.dart';
import '../../widgets/error_dialog.dart';
import '../homescreen/homescreen.dart';

class PakiDalaDetails extends StatefulWidget {
  double? pickUpAddressLat;
  double? pickUpAddressLng;
  double? dropOffAddressLat;
  double? dropOffAddressLng;
  String? dropoffplaceID;
  String? pickupplaceID;
  String? pickuplocation;
  String? dropofflocation;
  String? phone;
  String? sender;
  String? notes;
  String? size;
  String? weight;
  String? payment;

  PakiDalaDetails({
    this.dropoffplaceID,
    this.pickupplaceID,
    this.pickUpAddressLng,
    this.pickUpAddressLat,
    this.dropOffAddressLng,
    this.dropOffAddressLat,
    this.pickuplocation,
    this.dropofflocation,
    this.weight,
    this.size,
    this.notes,
    this.payment,
    this.phone,
    this.sender
  });

  @override
  State<PakiDalaDetails> createState() => _PakiDalaDetailsState();
}

class _PakiDalaDetailsState extends State<PakiDalaDetails> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controllerGMap = Completer();

  double bottomPaddingOfMap = 300;
  Position? currentPosition;
  GoogleMapController? newGoogleMapController;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  DirectionDetails? tripDirectionDetails;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.8848117, 122.2601717),
    zoom: 17,
  );

  showLocation(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c){
        return const LoadingDialog(message: "",);
      }
    );
    getPlaceDirection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap, top: 30),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            zoomControlsEnabled: false,
            rotateGesturesEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markers,
            circles: circles,
            onMapCreated: (GoogleMapController controller){
              _controllerGMap.complete(controller);
              newGoogleMapController = controller;
              showLocation();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: const Duration(milliseconds: 160),
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Pickup Location: ${widget.pickuplocation!}"
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("DropOff Location: ${widget.dropofflocation!}"
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("What Item: ${widget.notes!}"
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text("Phone Number: ${widget.phone!}"
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text((tripDirectionDetails != null) ? 'Distance: ${tripDirectionDetails!.distanceText!}': 'Test'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text((tripDirectionDetails != null) ? 'Estimated Time: ${tripDirectionDetails!.durationText!}': 'Test'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text((tripDirectionDetails != null) ? 'Price ₱${AssistantMethods.calculateFares(tripDirectionDetails!)}': 'Test'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text("Payment Method"),
                                ),
                                Expanded(
                                  child: Text(widget.payment!),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (c){
                                        return const LoadingDialog(message: "Creating Booking",);
                                      }
                                    );
                                    createBooking();
                                  },
                                  child: const Text(
                                    "Next",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      )
    );
  }
  Future<void> getPlaceDirection() async
  {
    var pickUpLatLng = LatLng(widget.pickUpAddressLat!, widget.pickUpAddressLng!);
    var dropOffLatLng = LatLng(widget.dropOffAddressLat!, widget.dropOffAddressLng!);

    var details = await AssistantMethods.obtainDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult = polylinePoints.decodePolyline(details!.encodedPoints.toString());

    pLineCoordinates.clear();
    if(decodedPolylinePointsResult.isNotEmpty)
    {
      decodedPolylinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;

    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,70));

    Marker pickUpLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: "Pick Up", snippet: "Pick Up"),
        position: pickUpLatLng,
        markerId: const MarkerId("pickUpId")
    );

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Drop off", snippet: "Drop off"),
        position: dropOffLatLng,
        markerId: const MarkerId("dropOffId")
    );

    setState(() {
      markers.add(pickUpLocMarker);
      markers.add(dropOffLocMarker);
    });

    Navigator.pop(context);
  }

  Future createBooking() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    if(widget.payment == "Top-up Load")
    {
      double newloadWallet = loadWallet - AssistantMethods.calculateFares(tripDirectionDetails!);
      if(newloadWallet > 0)
      {
        await FirebaseFirestore.instance.collection("booking")
            .doc(orderId).set({
          "pickupaddress": widget.pickuplocation,
          "pickupaddressLat": widget.pickUpAddressLat,
          "pickupaddressLng": widget.pickUpAddressLng,
          "dropoffaddress": widget.dropofflocation,
          "dropoffaddressLat": widget.dropOffAddressLat,
          "dropoffaddressLng": widget.dropOffAddressLng,
          "notes": widget.notes,
          "paymentMethods": widget.payment,
          "phoneNum": widget.phone,
          "price": AssistantMethods.calculateFares(tripDirectionDetails!),
          "orderTime": orderId,
          "serviceType": "paki-dala",
          "zone": zone,
          "isSuccess": true,
          "clientUID": sharedPreferences!.getString("email"),
          "riderUID": "",
          "status": "normal",
          "bookID": orderId,
        }).whenComplete(() {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => SideBarLayoutHome(page: 1,)));
          Fluttertoast.showToast(msg: "Congratulations, booking has been placed successfully.");
        }).then((value){
          FirebaseFirestore.instance
              .collection("pilamokoclient")
              .doc(sharedPreferences!.getString("email"))
              .update({
            "loadWallet": newloadWallet
          });
        });
      }
      else
      {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (c)
            {
              return const ErrorDialog(
                message: "Not enough load!",
              );
            }
        );
      }
    }
    else if(widget.payment == "COD")
    {
      await FirebaseFirestore.instance.collection("booking")
          .doc(orderId).set({
        "pickupaddress": widget.pickuplocation,
        "pickupaddressLat": widget.pickUpAddressLat,
        "pickupaddressLng": widget.pickUpAddressLng,
        "dropoffaddress": widget.dropofflocation,
        "dropoffaddressLat": widget.dropOffAddressLat,
        "dropoffaddressLng": widget.dropOffAddressLng,
        "notes": widget.notes,
        "paymentMethods": widget.payment,
        "phoneNum": widget.phone,
        "price": AssistantMethods.calculateFares(tripDirectionDetails!),
        "orderTime": orderId,
        "serviceType": "paki-dala",
        "zone": zone,
        "isSuccess": true,
        "clientUID": sharedPreferences!.getString("email"),
        "riderUID": "",
        "status": "normal",
        "bookID": orderId,
      }).whenComplete(() {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SideBarLayoutHome(page: 1,)));
        Fluttertoast.showToast(msg: "Congratulations, booking has been placed successfully.");
      });
    }
    else
    {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c)
          {
            return const ErrorDialog(
              message: "Please provide payment method.",
            );
          }
      );
    }
  }
}
