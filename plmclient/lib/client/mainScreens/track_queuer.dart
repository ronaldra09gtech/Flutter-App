import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../assistantMethods/assistant_methods.dart';
import '../assistantMethods/booking_details.dart';
import '../assistantMethods/req_assistant.dart';
import '../global/global.dart';
import '../models/direction_details.dart';
import 'home_Screen.dart';

class TrackQueuer extends StatefulWidget {
  final BookingDetails? bookingDetails;
   TrackQueuer({this.bookingDetails});

  @override
  State<TrackQueuer> createState() => _TrackQueuerState();
}

class _TrackQueuerState extends State<TrackQueuer> {
  Completer<GoogleMapController> _controllerGMap = Completer();
  GoogleMapController? newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails? tripDirectionDetails;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  Position? currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;
  double searchContainerHeight = 340;
  double rideDetailsContainerHeight = 0;

  double queuerlat=0;
  double queuerlng=0;
  displayRideDetailsContainer()
  {
    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight=240;
      bottomPaddingOfMap = 230;
    });
  }

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(13.8848117, 122.2601717),
    zoom: 17,
  );

  int seconds=0;
  bool stop=false;
  void _startTimer()
  {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });

      if(seconds>=3)
      {
        getLocationLiveUpdates();
        setState(() {
          seconds=0;
        });
      }
      if(stop)
      {
        timer.cancel();
      }
    });
  }


  StreamSubscription<Position>? homeTabPageStreamSubscription;
  DocumentReference? usersRef =  FirebaseFirestore.instance
      .collection("pilamokoQueuerAvailableDrivers")
      .doc(sharedPreferences!.getString("email"));

  getLocationLiveUpdates()
  {
    FirebaseFirestore.instance
        .collection("pilamokoQueuerAvailableDrivers")
        .doc(widget.bookingDetails!.riderUID)
        .get()
        .then((snap){
          setState(() {
            queuerlat = snap.data()!['lat'];
            queuerlng = snap.data()!['lng'];
          });
          print(queuerlat);
          getPlaceDirection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Queuer Tracking"),
        leading: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
            },
            child: Icon(Icons.arrow_back)
        ),
      ),
    body: Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
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
                        _startTimer();
                        displayRideDetailsContainer();
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
                              Text("Show Queuer Location")
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
                            Image.asset("images/client.png",height: 70, width: 80,),
                            SizedBox(width: 16,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Travel Estimation", style: TextStyle(fontSize: 18, fontFamily: "Brand"),),
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
                              launch('sms://09155835173');
                              // getDropOffDirection();
                              // displayDropOffContainer();
                              // confirmParcelHasBeenPicked(widget.bookingDetails!.bookID!);
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
                                    Text("Message Queuer")
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
                              launch('tel://09155835173');
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
                                    Text("Call Queuer")
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
                          child: Text("What Item: "),
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
      ],
    )
    );
  }
  Future<void> getPlaceDirection() async
  {
    var pickUpLatLng = LatLng(double.parse(widget.bookingDetails!.pickupaddresslat.toString()), double.parse(widget.bookingDetails!.pickupaddresslng.toString()));
    var dropOffLatLng = LatLng(double.parse(widget.bookingDetails!.dropoffaddresslat.toString()), double.parse(widget.bookingDetails!.dropoffaddresslng.toString()));

    var queuerLatLng = LatLng(queuerlat, queuerlng);

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

    Marker queuerLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: "Queuer", snippet: "Queuer"),
        position: queuerLatLng,
        markerId: MarkerId("queuerId")
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
      markers.add(queuerLocMarker);
    });
  }
}
