import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plmclient/queuer/Datahandler/appData.dart';
import 'package:plmclient/queuer/assistantMethods/assistant_methods.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/home_screen.dart';
import 'package:plmclient/queuer/maps/search_screen.dart';
import 'package:plmclient/queuer/models/direction_details.dart';
import 'package:plmclient/queuer/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

import '../../main.dart';


class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}



class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGMap = Completer();
  GoogleMapController? newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails? tripDirectionDetails;
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  Position? currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  double rideDetailsContainerHeight = 0;
  double searchContainerHeight = 300;
  double reqRideContainerHeight = 0;

  bool drawerOpen = true;

  displayReqRide()
  {
    setState(() {
      reqRideContainerHeight = 250;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230;
      drawerOpen = true;
    });
  }

  resetApp()
  {
    setState(() {
      searchContainerHeight=300;
      rideDetailsContainerHeight=0;
      reqRideContainerHeight = 0;
      bottomPaddingOfMap = 230;
      drawerOpen = true;

      polylineSet.clear();
      markers.clear();
      circles.clear();
      pLineCoordinates.clear();
    });
    locatePosition();
  }


  void displayRideDetailsContainer() async
  {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight=240;
      bottomPaddingOfMap = 230;
      drawerOpen = false;
    });
  }


  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print(address);


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
      drawer: Container(
        color: Colors.white,
        width: 255,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Column(
                        children:  [
                          //header drawer
                          Material(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Container(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      sharedPreferences!.getString("photoUrl")!
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Profile Name",style: TextStyle(fontSize: 16, fontFamily: "Brand"),),
                          SizedBox(width: 16,),
                          Text("Visit Profile",),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),

              SizedBox(height: 12,),

              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize: 15),),
              ),
              Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Visit Profile", style: TextStyle(fontSize: 15),),
              ),
              Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                } ,
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize: 15),),
              ),
              Divider(
                height: 1,
                color: Colors.black,
                thickness: 1,
              ),
            ],
          ),
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
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markers,
            circles: circles,
            onMapCreated: (GoogleMapController controller){
              _controllerGMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300;
              });

              locatePosition();
            },
          ),

          Positioned(
            top: 38,
            left: 22,
            child: GestureDetector(
              onTap: (){
                if(drawerOpen){
                  scaffoldKey.currentState?.openDrawer();
                }
                else{
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6,
                        spreadRadius: 0.5,
                        offset: Offset(0.7,0.7),
                      ),
                    ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon((drawerOpen) ? Icons.menu : Icons.close, color: Colors.black,),
                  radius: 20,
                ),
              ),
            ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6,),
                      Text("Hi There", style: TextStyle(fontSize: 10),),
                      Text("Where to?", style: TextStyle(fontSize: 20, fontFamily: "Brand"),),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () async
                        {
                          var res = await Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchScreen()));
                          if(res == "obtainDirections")
                          {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                              children: [
                                Icon(Icons.search, color: Colors.blue,),
                                SizedBox(width: 10,),
                                Text("Search Drop Off")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:10,),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey,),
                          SizedBox(width: 5,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  Provider.of<AppData>(context).pickUpLocation != null
                                      ? Provider.of<AppData>(context).pickUpLocation!.placename.toString()
                                      : "Add Home"
                              ),
                              SizedBox(height: 4,),
                              Text("Home Address", style: TextStyle(color: Colors.black54,fontSize: 12),),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10,),
                      Divider(
                        height: 1,
                        color: Colors.black,
                        thickness: 1,
                      ),
                      SizedBox(height:10,),
                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.grey,),
                          SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work",),
                              SizedBox(height: 4,),
                              Text("Office Address", style: TextStyle(color: Colors.black54,fontSize: 12),),
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
                  padding: EdgeInsets.symmetric(vertical: 17),
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
                                  Text("Queuer", style: TextStyle(fontSize: 18, fontFamily: "Brand"),),
                                  Text(((tripDirectionDetails != null) ?tripDirectionDetails!.distanceText.toString() : ''), style: TextStyle(fontSize: 18, color: Colors.grey),)
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                ((tripDirectionDetails != null) ? '\₱${AssistantMethods.calculateFares(tripDirectionDetails!)}': ''),
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 16,),
                            Text("Cash"),
                            SizedBox(width: 6,),
                            Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16,),

                          ],
                        ),
                      ),
                      SizedBox(height: 24,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: RaisedButton(
                          onPressed: (){
                            displayReqRide();
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Request", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16,
                        color: Colors.black54,
                        offset: Offset(0.7,0.7)
                    )
                  ]
              ),
              height: reqRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    SizedBox(
                      width: double.infinity,
                      child: ColorizeAnimatedTextKit(
                        onTap: (){},
                        text: [
                          "Requesting a Ride",
                          "Please Wait...",
                          "Finding a Rider..."
                        ],
                        textStyle: TextStyle(
                            fontSize: 40,
                            fontFamily: "Brand"
                        ),
                        colors: [
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red
                        ],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 22,),

                    GestureDetector(
                      onTap: (){
                        resetApp();
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(width: 2, color: Colors.black54),
                        ),
                        child: Icon(Icons.close, size: 26, color: Colors.grey, ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      child: Text("Cancel", textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos!.latitude!.toDouble(), initialPos.longitude!.toDouble());
    var dropOffLatLng = LatLng(finalPos!.latitude!.toDouble(), finalPos.longitude!.toDouble());

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
        infoWindow: InfoWindow(title: initialPos.placename, snippet: "My Location"),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: finalPos.placename, snippet: "DropOff Location"),
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

