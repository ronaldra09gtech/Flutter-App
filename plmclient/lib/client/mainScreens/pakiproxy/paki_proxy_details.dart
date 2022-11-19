import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/assistantMethods/req_assistant.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/home_screen.dart';
import 'package:plmclient/client/mainScreens/my_booking_screen.dart';
import 'package:plmclient/client/mainScreens/pakidala/paki_dala_screen.dart';
import 'package:plmclient/client/models/direction_details.dart';

import '../../../main.dart';
import '../../widgets/error_dialog.dart';


class PakiProxyBookingDetails extends StatefulWidget {

  String? pickupplaceID;
  String? dropoffplaceID;
  String? pickuplocation;
  String? dropofflocation;
  String? notes;
  String? phone;
  PakiProxyBookingDetails({this.phone,this.dropoffplaceID,this.pickupplaceID,this.notes,this.dropofflocation,this.pickuplocation});
  @override
  _PakiProxyBookingDetailsState createState() => _PakiProxyBookingDetailsState();
}

class _PakiProxyBookingDetailsState extends State<PakiProxyBookingDetails> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGMap = Completer();
  GoogleMapController? newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails? tripDirectionDetails;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  double searchContainerHeight = 340;

  Position? currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  double? pickuplatitude;
  double? pickuplongitude;
  double? dropofflongitude;
  double? dropofflatitude;
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  String? valueChoose;
  List listItem = [
    "Cash on Delivery","Topup Load"
  ];
  bool isDriverOnline=false;
  @override
  void initState() {
    super.initState();
    getPickupPlaceAddressDetails(widget.pickupplaceID!);
    searchDriverOnline();
  }

  searchDriverOnline()
  {
    FirebaseFirestore.instance
        .collection("pilamokoQueuerAvailableDrivers").where("status", isEqualTo: "online")
        .get()
        .then((snapshot){
      if(snapshot.docs.isNotEmpty)
      {
        isDriverOnline=true;
      }
      else
      {
        isDriverOnline=false;
      }
    });
  }

  void getPickupPlaceAddressDetails(String placeId) async
  {
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=$apiKey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if(res == "failed"){
      return;
    }

    if(res["status"]=="OK")
    {

      setState(() {
        pickuplatitude = res["result"]["geometry"]["location"]["lat"];
        pickuplongitude = res["result"]["geometry"]["location"]["lng"];
      });
      getDropOffPlaceAddressDetails(widget.dropoffplaceID!);
    }
  }

  void getDropOffPlaceAddressDetails(String placeId) async
  {
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=AIzaSyAdQzvrdWzzOwTCGrL0joXXVh41UHtcUIw";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if(res == "failed"){
      return;
    }

    if(res["status"]=="OK")
    {
      setState(() {
        dropofflatitude = res["result"]["geometry"]["location"]["lat"];
        dropofflongitude = res["result"]["geometry"]["location"]["lng"];
      });
      await getPlaceDirection();
    }
  }

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address = await AssistantMethods.searchCoordinateAddress(position, context);
    // print(address);

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.8848117, 122.2601717),
    zoom: 17,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markers,
            circles: circles,
            onMapCreated: (GoogleMapController controller){
              _controllerGMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 200;
              });

              locatePosition();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
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
                      SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                color: Colors.grey[200],
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text("Pickup Location: " + widget.pickuplocation!
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
                                      child: Text("DropOff Location: " + widget.dropofflocation!
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
                                      child: Text("What Item: " + widget.notes!
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
                                      child: Text("Phone Number: " + widget.phone!
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
                                      child: Text((tripDirectionDetails != null) ? 'Distance\: ${tripDirectionDetails!.distanceText!}': ''),
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
                                      child: Text((tripDirectionDetails != null) ? 'Estimated Time\: ${tripDirectionDetails!.durationText!}': ''),
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
                                      child: Text((tripDirectionDetails != null) ? 'Estimated Price \₱${AssistantMethods.calculateFaresPakiProxy()}': ""),
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
                                      child: Text("Payment Method"),
                                    ),
                                    Expanded(
                                      child: DropdownButton(
                                        value: valueChoose,
                                        onChanged: (newValue){
                                          setState(() {
                                            valueChoose = newValue as String?;
                                          });
                                          print(valueChoose);
                                        },
                                        items: listItem.map((valueItem){
                                          return DropdownMenuItem(
                                            value: valueItem,
                                            child: Text(valueItem),
                                          );
                                        }).toList(),
                                      ),
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
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // createBooking();
                                        setState(() {
                                          pickupController.clear();
                                          dropoffController.clear();
                                          placePredictionList.clear();
                                          dropOffPlacePredictionList.clear();
                                          orderId = "";
                                          markers.clear();
                                          circles.clear();
                                          pLineCoordinates.clear();
                                          polylineSet.clear();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                                        });

                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                      child: const Text(
                                        "Next",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                      onPressed: () {
                                        searchDriverOnline();
                                        createBooking();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> getPlaceDirection() async
  {
    var pickUpLatLng = LatLng(pickuplatitude!, pickuplongitude!);
    var dropOffLatLng = LatLng(dropofflatitude!, dropofflongitude!);

    var details = await AssistantMethods.obtainDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    print(details!.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResult = polylinePoints.decodePolyline(details.encodedPoints.toString());

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
        polylineId: PolylineId("PolylineID"),
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
        infoWindow: InfoWindow(title: "Drop Off", snippet: "Drop Off"),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: "Pick Up", snippet: "Drop Off"),
        position: dropOffLatLng,
        markerId: MarkerId("dropOffId")
    );

    setState(() {
      markers.add(pickUpLocMarker);
      markers.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blue,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.red,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circles.add(pickUpLocCircle);
      circles.add(dropOffLocCircle);
    });

  }
  Future createBooking() async {
    if(isDriverOnline)
    {
      if(valueChoose == "Topup Load")
      {
        if(double.parse(loadWallet) > AssistantMethods.calculateFares(tripDirectionDetails!))
        {
          double newloadWallet = double.parse(loadWallet) - AssistantMethods.calculateFares(tripDirectionDetails!);
          await FirebaseFirestore.instance.collection("booking")
              .doc(orderId).set({
            "pickupaddress": widget.pickuplocation,
            "pickupaddressLat": pickuplatitude,
            "pickupaddressLng": pickuplongitude,
            "dropoffaddress": widget.dropofflocation,
            "dropoffaddressLat": dropofflatitude,
            "dropoffaddressLng": dropofflongitude,
            "notes": widget.notes,
            "phoneNum": widget.phone,
            "price": AssistantMethods.calculateFaresPerhr(tripDirectionDetails!),
            "paymentMethods": valueChoose,
            "orderTime": orderId,
            "serviceType": "paki-proxy",
            "zone": zone,
            "isSuccess": true,
            "clientUID": sharedPreferences!.getString("email"),
            "riderUID": "",
            "status": "normal",
            "bookID": orderId,
          }).then((value){
            FirebaseFirestore.instance.collection("pilamokoclient")
                .doc(sharedPreferences!.getString("email"))
                .collection("booking")
                .doc(orderId)
                .set({
              "pickupaddress": widget.pickuplocation,
              "pickupaddressLat": pickuplatitude,
              "pickupaddressLng": pickuplongitude,
              "dropoffaddress": widget.dropofflocation,
              "dropoffaddressLat": dropofflatitude,
              "dropoffaddressLng": dropofflongitude,
              "notes": widget.notes,
              "phoneNum": widget.phone,
              "price": AssistantMethods.calculateFaresPerhr(tripDirectionDetails!),
              "paymentMethods": valueChoose,
              "orderTime": orderId,
              "serviceType": "paki-proxy",
              "zone": zone,
              "isSuccess": true,
              "clientUID": sharedPreferences!.getString("email"),
              "riderUID": "",
              "status": "normal",
              "bookID": orderId,
            });
          }).whenComplete(() {
            setState(() {
              pickupController.clear();
              dropoffController.clear();
              placePredictionList.clear();
              dropOffPlacePredictionList.clear();
              orderId = "";
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingScreen()));
              Fluttertoast.showToast(msg: "Congratulations, booking has been placed successfully.");
            });
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
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: "Not enough load!",
                );
              }
          );
        }
      }
      else if(valueChoose == "Cash on Delivery")
      {
        await FirebaseFirestore.instance.collection("booking")
            .doc(orderId).set({
          "pickupaddress": widget.pickuplocation,
          "pickupaddressLat": pickuplatitude,
          "pickupaddressLng": pickuplongitude,
          "dropoffaddress": widget.dropofflocation,
          "dropoffaddressLat": dropofflatitude,
          "dropoffaddressLng": dropofflongitude,
          "notes": widget.notes,
          "phoneNum": widget.phone,
          "price": AssistantMethods.calculateFaresPakiProxy(),
          "paymentMethods": valueChoose,
          "orderTime": orderId,
          "serviceType": "paki-proxy",
          "zone": zone,
          "isSuccess": true,
          "clientUID": sharedPreferences!.getString("email"),
          "riderUID": "",
          "status": "normal",
          "bookID": orderId,
        }).then((value){
          FirebaseFirestore.instance.collection("pilamokoclient")
              .doc(sharedPreferences!.getString("email"))
              .collection("booking")
              .doc(orderId)
              .set({
            "pickupaddress": widget.pickuplocation,
            "pickupaddressLat": pickuplatitude,
            "pickupaddressLng": pickuplongitude,
            "dropoffaddress": widget.dropofflocation,
            "dropoffaddressLat": dropofflatitude,
            "dropoffaddressLng": dropofflongitude,
            "notes": widget.notes,
            "phoneNum": widget.phone,
            "price": AssistantMethods.calculateFaresPakiProxy(),
            "paymentMethods": valueChoose,
            "orderTime": orderId,
            "serviceType": "paki-proxy",
            "zone": zone,
            "isSuccess": true,
            "clientUID": sharedPreferences!.getString("email"),
            "riderUID": "",
            "status": "normal",
            "bookID": orderId,
          });
        }).whenComplete(() {
          setState(() {
            pickupController.clear();
            dropoffController.clear();
            placePredictionList.clear();
            dropOffPlacePredictionList.clear();
            orderId = "";
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingScreen()));
            Fluttertoast.showToast(msg: "Congratulations, booking has been placed successfully.");
          });
        });
      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please provide payment method.",
              );
            }
        );
      }
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "There's no Available Queuer.",
            );
          }
      );
    }

  }
}

