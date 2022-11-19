import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plmclient/queuer/assistantMethods/assistant_methods.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/bike_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/home_screen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/walker_homescreen.dart';
import 'package:plmclient/queuer/models/booking_details.dart';
import 'package:plmclient/queuer/models/direction_details.dart';
import 'package:plmclient/queuer/widgets/loading_dialog.dart';
import 'package:signature/signature.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image/image.dart' as encoder;
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:intl/intl.dart';

import '../../../main.dart';

class PakiDalaDirectionScreen extends StatefulWidget {

  final BookingDetails? bookingDetails;
  PakiDalaDirectionScreen({this.bookingDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.8848117, 122.2601717),
    zoom: 17,
  );

  @override
  State<PakiDalaDirectionScreen> createState() => _PakiDalaDirectionScreenState();
}

class _PakiDalaDirectionScreenState extends State<PakiDalaDirectionScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGMap = Completer();
  GoogleMapController? newGoogleMapController;
  Set<Marker> markers = {};
  Set<Circle> circles = {};  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  PolylinePoints polylinePoints = PolylinePoints();
  DirectionDetails? tripDirectionDetails;

  Position? currentPosition;

  double rideDetailsContainerHeight = 0;
  double dropOffContainerHeight = 0;
  double searchContainerHeight = 0;
  double signatureContainerHeight = 0;
  double bottomPaddingOfMap = 100;

  String signature="";

  final SignatureController _controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.blue
  );

  var geolocator = Geolocator();

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    Navigator.pop(context);
    // String address = await AssistantMethods.searchCoordinateAddress(position, context);
    // print(address);
  }

  displayRideDetailsContainer()
  {
    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight=240;
      bottomPaddingOfMap = 230;
    });
  }

  displayDropOffContainer()
  {
    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight=0;
      dropOffContainerHeight=240;
      bottomPaddingOfMap = 230;
    });
  }

  displaySignatureContainer()
  {
    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight=0;
      dropOffContainerHeight=0;
      signatureContainerHeight=400;
      bottomPaddingOfMap = 230;
    });
  }

  void getLocationLiveUpdates()
  {
    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      usersRef!.update({
        "lat": position.latitude,
        "lng": position.longitude,
      });
    });
  }

  confirmParcelHasBeenPicked(getOrderID)
  {
    FirebaseFirestore.instance
        .collection("booking")
        .doc(getOrderID).update({
      "status": "delivering",
      "riderUID": sharedPreferences!.getString("email"),
    });
  }

  confirmParcelHasBeenDelivered(getOrderID)
  {
    FirebaseFirestore.instance
        .collection("booking")
        .doc(getOrderID).update({
      "status": "ended",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text(
            "PickUp Location",
            style: const TextStyle(fontSize: 45.0, letterSpacing: 3, color: Colors.white, fontFamily: "Signatra"),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: 100),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: PakiDalaDirectionScreen._kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              polylines: polylineSet,
              markers: markers,
              circles: circles,
              onMapCreated: (GoogleMapController controller) async{
                _controllerGMap.complete(controller);
                newGoogleMapController = controller;
                showDialog(
                    context: context,
                    builder: (BuildContext context) => LoadingDialog(message: "Please Wait...",)
                );
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
                  height: 100,
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6,),
                        GestureDetector(
                          onTap: () async
                          {
                            getPlaceDirection();
                            displayRideDetailsContainer();
                            getLocationLiveUpdates();

                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7,0.7),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: const [
                                  SizedBox(width: 10,),
                                  Text("Show Pickup Location")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: rideDetailsContainerHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16,
                          spreadRadius: 0.5,
                          offset: Offset(0.7,0.7),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.lightBlueAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16,),
                            child: Row(
                              children: [
                                Image.asset("images/signup.png",height: 70, width: 80,),
                                SizedBox(width: 16,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Pickup Location", style: TextStyle(fontSize: 18, fontFamily: "Brand"),),
                                    Text(((tripDirectionDetails != null) ?tripDirectionDetails!.distanceText.toString() : ''), style: TextStyle(fontSize: 18, color: Colors.black),),

                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((tripDirectionDetails != null) ? tripDirectionDetails!.durationText.toString(): ''),
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              child: GestureDetector(
                                onTap: () async
                                {
                                  getDropOffDirection();
                                  displayDropOffContainer();
                                  confirmParcelHasBeenPicked(widget.bookingDetails!.bookID!);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7,0.7),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: const [
                                        Text("Parcel Has Been PickUp")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              child: GestureDetector(
                                onTap: () async
                                {
                                  var number = widget.bookingDetails!.phoneNum.toString();
                                  launch('tel://$number');
                                  print(number);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7,0.7),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: const [
                                        Text("Call Client")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text("Notes: "),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(widget.bookingDetails!.notes!),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: dropOffContainerHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16,
                          spreadRadius: 0.5,
                          offset: Offset(0.7,0.7),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.lightBlueAccent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16,),
                            child: Row(
                              children: [
                                Image.asset("images/signup.png",height: 70, width: 80,),
                                SizedBox(width: 16,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Drop Off Location", style: TextStyle(fontSize: 18, fontFamily: "Brand"),),
                                    Text(((tripDirectionDetails != null) ?tripDirectionDetails!.distanceText.toString() : ''), style: TextStyle(fontSize: 18, color: Colors.black),),

                                  ],
                                ),
                                Expanded(child: Container()),
                                Text(
                                  ((tripDirectionDetails != null) ? tripDirectionDetails!.durationText.toString(): ''),
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              child: GestureDetector(
                                onTap: () async
                                {
                                  displaySignatureContainer();
                                  // confirmParcelHasBeenDelivered(widget.bookingDetails!.bookID!);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7,0.7),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: const [
                                        Text("Parcel Has Been Delivered")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                              child: GestureDetector(
                                onTap: () async
                                {
                                  var number = widget.bookingDetails!.phoneNum.toString();
                                  launch('tel://$number');
                                  print(number);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7,0.7),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: const [
                                        Text("Call Client")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: signatureContainerHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 16,
                          spreadRadius: 0.5,
                          offset: Offset(0.7,0.7),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16,),
                            child: Signature(
                              controller: _controller,
                              height: 300,
                              backgroundColor: Colors.lightBlue,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                          height: 60,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: GestureDetector(
                                  onTap: () async
                                  {
                                    _controller.clear();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 6,
                                          spreadRadius: 0.5,
                                          offset: Offset(0.7,0.7),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: const [
                                          Text("Clear")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: GestureDetector(
                                  onTap: () async
                                  {
                                    if(_controller.isNotEmpty)
                                    {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) => LoadingDialog(message: "Please Wait...",)
                                      );
                                      var image = await _controller.toImage();

                                      int height = image!.height;
                                      int width = image.width;

                                      ByteData? data = await image.toByteData();
                                      Uint8List? listData = data!.buffer.asUint8List();

                                      encoder.Image toEncodeImage = encoder.Image.fromBytes(width, height, listData);
                                      encoder.JpegEncoder jpgEncoder = encoder.JpegEncoder();

                                      List<int> encodedImage = jpgEncoder.encodeImage(toEncodeImage);

                                      final FirebaseStorage storage = FirebaseStorage.instance;
                                      final String picture = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
                                      fStorage.Reference reference = fStorage.FirebaseStorage.instance
                                          .ref()
                                          .child("bookingSigns")
                                          .child(picture);
                                      fStorage.UploadTask uploadTask = reference.putData(Uint8List.fromList(encodedImage));
                                      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
                                      await taskSnapshot.ref.getDownloadURL().then((url) {
                                        signature = url;
                                      });
                                      confirmParcelHasBeenDelivered(widget.bookingDetails!.bookID);
                                      FirebaseFirestore.instance
                                          .collection("booking")
                                          .doc(widget.bookingDetails!.bookID)
                                          .update({
                                        "signatureUrl":signature,
                                      }).then((value){
                                        if(widget.bookingDetails!.paymentmethod == "Cash on Delivery")
                                        {
                                          double subtotal = double.parse(widget.bookingDetails!.price.toString()) * double.parse(pakiPilafees);
                                          double newload = double.parse(load) - subtotal;

                                          FirebaseFirestore.instance
                                              .collection("pilamokoqueuer")
                                              .doc(sharedPreferences!.getString("email"))
                                              .update({
                                            "loadWallet":newload.round(),
                                          }).then((value) {
                                            FirebaseFirestore.instance
                                                .collection("incometable")
                                                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                                                .set({
                                              "incomepercentage":subtotal,
                                              "logdate":DateTime.now().millisecondsSinceEpoch.toString(),
                                              "services":widget.bookingDetails!.serviceType,
                                              "year": DateFormat('yyyy').format(DateTime.now()),
                                              "month": DateFormat('MMM').format(DateTime.now()),
                                              "day": DateFormat('d').format(DateTime.now()),
                                              "date":DateFormat("dd MMMM, yyyy - hh:mm aa")
                                                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now().millisecondsSinceEpoch.toString()))),
                                            });
                                          });
                                        }
                                        else
                                        {
                                          double? price = double.parse(widget.bookingDetails!.price.toString());
                                          double subtotal = price *  double.parse(pakiPilafees);
                                          double total = price - subtotal;
                                          double newloadbal = double.parse(load) + total;
                                          FirebaseFirestore.instance
                                              .collection("pilamokoqueuer")
                                              .doc(sharedPreferences!.getString("email"))
                                              .update({
                                            "loadWallet":newloadbal.round(),
                                          }).then((value){
                                            FirebaseFirestore.instance
                                                .collection("incometable")
                                                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                                                .set({
                                              "incomepercentage":subtotal,
                                              "logdate":DateTime.now().millisecondsSinceEpoch.toString(),
                                              "services":widget.bookingDetails!.serviceType,
                                              "year": DateFormat('yyyy').format(DateTime.now()),
                                              "month": DateFormat('MMM').format(DateTime.now()),
                                              "day": DateFormat('d').format(DateTime.now()),
                                              "date":DateFormat("dd MMMM, yyyy - hh:mm aa")
                                                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now().millisecondsSinceEpoch.toString()))),
                                            });
                                          });
                                        }
                                      }).whenComplete((){
                                        Navigator.pop(context);
                                        if(sharedPreferences!.getString("queuerType")!.toString() == "Walking Queuer"){
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerHomeScreen()));
                                        }
                                        else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Bike / Bike"){
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=> BikerHomeScreen()));
                                        }
                                        else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Motorcycle" || sharedPreferences!.getString("queuerType")!.toString() == "Queuer with 4 Wheels"){
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          blurRadius: 6,
                                          spreadRadius: 0.5,
                                          offset: Offset(0.7,0.7),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: const [
                                          Text("Submit")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6,),
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
    var pickUpLatLng = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    var dropOffLatLng = LatLng(widget.bookingDetails!.pickupaddresslat!, widget.bookingDetails!.pickupaddresslng!);

    showDialog(
        context: context,
        builder: (BuildContext context) => LoadingDialog(message: "Please Wait...",)
    );

    var details = await AssistantMethods.obtainDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
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
        infoWindow: InfoWindow(title: "My Location", snippet: "My Location"),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: "DropOff Location", snippet: "DropOff Location"),
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

  Future<void> getDropOffDirection() async
  {
    var pickUpLatLng = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    var dropOffLatLng = LatLng(widget.bookingDetails!.dropoffaddresslat!, widget.bookingDetails!.dropoffaddresslng!);

    showDialog(
        context: context,
        builder: (BuildContext context) => LoadingDialog(message: "Please Wait...",)
    );

    var details = await AssistantMethods.obtainDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
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
        infoWindow: InfoWindow(title: "My Location", snippet: "My Location"),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: "DropOff Location", snippet: "DropOff Location"),
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
}