import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plmclient/queuer/assistantMethods/get_current_location.dart';
import 'package:plmclient/queuer/authentication/authScreen.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/emall/emall_order_screen.dart';
import 'package:plmclient/queuer/mainScreens/emarket/emarket_order_screen.dart';
import 'package:plmclient/queuer/mainScreens/history/history_screen.dart';
import 'package:plmclient/queuer/mainScreens/my_tlp.dart';
import 'package:plmclient/queuer/mainScreens/paki-dala/paki_dala_screen.dart';
import 'package:plmclient/queuer/mainScreens/paki-pila/paki_pila_screen.dart';
import 'package:plmclient/queuer/mainScreens/paki-proxy/paki_proxy_screen.dart';
import 'package:plmclient/queuer/mainScreens/validation/has_validation.dart';
import 'package:plmclient/queuer/widgets/my_drawer.dart';

import '../../../main.dart';
import '../../authentication/pick_tlp_screen.dart';
import '../../widgets/error_dialog.dart';
import '../eresto/eresto_order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String driverStatusText = "Offline";

  String queuerstatus="";
  bool isqueuerbanned=false;
  Color driverStatusColor = Colors.black;
  bool isqueuervalidated = false;
  Position? position;
  List<Placemark>? placeMarks;

  bool isDriverAvailable = false;
  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
    '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality}, ${pMark.locality}, ${pMark.subAdministrativeArea},${pMark.administrativeArea}, ${pMark.country}';

    setState(() {
      zone = '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea} ${pMark.administrativeArea}';
    });

    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email"))
        .update({
      "zone":zone,
    });
  }



  @override
  void initState() {
    super.initState();
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
    getRiderRequirements();
    isDriverAvailablee();
    if(isqueuerbanned){
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "You're Account is banned.",
            );
          });
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> AuthScreen()));
    }
  }

  getRiderRequirements()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email"))
        .get()
        .then((snap){
      setState(() {
        isqueuervalidated = snap.data()!['isValidated'];
        pilamokoqueuerLicenseUrl = snap.data()!['pilamokoqueuerLicenseUrl'].toString();
        pilamokoqueuerOrcrUrl = snap.data()!['pilamokoqueuerOrcrUrl'].toString();
        pilamokoqueuerBillingUrl = snap.data()!['pilamokoqueuerBillingUrl'].toString();
        validID = snap.data()!['validID'].toString();
      });
    });
  }

  makeQueuerOnline()
  {
    FirebaseFirestore.instance
        .collection("pilamokoQueuerAvailableDrivers")
        .doc(sharedPreferences!.getString("email"))
        .update({
      "status":"online",
    });
  }

  makeQueuerOffline()
  {
    FirebaseFirestore.instance
        .collection("pilamokoQueuerAvailableDrivers")
        .doc(sharedPreferences!.getString("email"))
        .update({
      "status":"offline",
    });
  }

  isDriverAvailablee()
  {
    FirebaseFirestore.instance
        .collection("pilamokoQueuerAvailableDrivers")
        .doc(sharedPreferences!.getString("email"))
        .get()
        .then((snap){
          setState(() {
            queuerstatus = snap.data()!['status'].toString();
          });
        }).then((value){
          if(queuerstatus =="online")
          {
            setState(() {
              isDriverAvailable = true;
              driverStatusText = "Online";
            });
          }
          else
          {
            setState(() {
              isDriverAvailable = false;
            });
          }
    });
  }

  getRiderPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email"))
        .get()
        .then((snap){
          setState(() {
            previousRiderEarnings = snap.data()!['earning'].toString();
            load = snap.data()!['loadWallet'].toString();
            email = snap.data()!['pilamokoqueuerEmail'].toString();
            phone = snap.data()!['phone'].toString();
            address = snap.data()!['address'].toString();
            zone = snap.data()!['zone'].toString();
            tlp = snap.data()!['tlp'].toString();
          });
          if(snap.data()!['status'].toString() =="approved")
          {

          }
          else {
            setState(() {
              isqueuerbanned = true;
            });
          }
    });
  }

  getPerParcelDeliveryAmount()
  {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("pakiBili")
        .get().then((snap){
          setState((){
            perParcelDeliveryAmount = snap.data()!["amount"].toString();
          });
    }).then((value){
      FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("paki-pila")
          .get().then((snap){
            setState((){
              perhalfhr = snap.data()!["perhour"].toString();
              basefee = snap.data()!["baseFee"].toString();
              pakiPilafees = snap.data()!["fees"].toString();
            });
      });
    }).then((value){
      FirebaseFirestore.instance
          .collection("perDelivery")
          .doc("paki-dala")
          .get().then((snap){
        setState(() {
          pakiDalafees = snap.data()!["fees"].toString();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "Welcome " +
              sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem(driverStatusText, Icons.account_circle_rounded, 0,),
            Card(
              elevation: 2,
              margin: const EdgeInsets.all(8),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.blue,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: InkWell(
                  onTap:() {
                    showDialog(
                        context: context,
                        builder: (c)
                        {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10,),
                                const Text("Are you sure you want to Change Zone?"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24.0),
                                      ),
                                      onPressed: ()
                                      {
                                        Navigator.pop(context);
                                      },
                                      color: Colors.blueAccent,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text("No", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                        ],
                                      ),
                                    ),
                                    RaisedButton(
                                      shape: new RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(24.0),
                                      ),
                                      onPressed: ()
                                      {
                                        getCurrentLocation();
                                        Navigator.pop(context);
                                      },
                                      color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text("Yes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: [
                      const SizedBox(height: 48.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            zone,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Center(
                        child: Text(
                          "zone",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            makeDashboardItem("Document Filling Assistant", Icons.file_copy_outlined,2),
            makeDashboardItem("E-Restaurant Orders", Icons.business_outlined, 3),
            makeDashboardItem("E-Market Orders", Icons.add_business, 4),
            makeDashboardItem("E-Mall Orders", Icons.business_center_outlined, 5),
            makeDashboardItem("Paki-Dala", Icons.markunread_mailbox, 6),
            makeDashboardItem("Paki-Pila Bayad", Icons.airline_seat_recline_normal_sharp, 7),
            makeDashboardItem("Paki-Pila Proxy", Icons.person_pin, 8),
          ],
        ),
      ),
    );
  }
  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
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
        )
            : const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.blue,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: InkWell(
          onTap:() {
            if(index == 0)
            {
              //New Available order
              if(isDriverAvailable != true)
              {
                makeQueuerOnline();
                setState(() {
                  driverStatusColor = Colors.green;
                  driverStatusText = "You're Online now ";
                  isDriverAvailable = true;
                });
                Fluttertoast.showToast(
                    msg: "You're Online now.");
              }
              else
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10,),
                            const Text("Are you sure you want to Offline?"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  onPressed: ()
                                  {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.blueAccent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("No", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                    ],
                                  ),
                                ),
                                RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(24.0),
                                  ),
                                  onPressed: ()
                                  {
                                    makeQueuerOffline();
                                    setState(() {
                                      driverStatusColor = Colors.black;
                                      driverStatusText = "Offline Now";
                                      isDriverAvailable = false;
                                    });
                                    Navigator.pop(context);

                                  },
                                  color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Yes", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
            }
            if(index == 2)
            {
              //Parcels in progress
            }
            if(index == 3)
            {
              //Eresto
              if(isqueuervalidated)
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> ErestoOrderScreen()));
              }
              else
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorDialog(
                        message: "Account Need Validation",
                      );
                    }
                );
              }
              // Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
            }
            if(index == 4)
            {
              //Emarket
              if(isqueuervalidated)
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> EmarketOrderScreen()));
              }
              else
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorDialog(
                        message: "Account Need Validation",
                      );
                    }
                );
              }
            }
            if(index == 5)
            {
              //Emall
              if(isqueuervalidated)
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=> EmallOrderScreen()));
              }
              else
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorDialog(
                        message: "Account Need Validation",
                      );
                    }
                );
              }

            }
            if(index == 6)
            {
              //PakiDala
              if(isqueuervalidated)
              {
                if(double.parse(load) >= 100)
                {
                  if(isDriverAvailable)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiDalaScreen()));
                  }
                  else
                  {
                    showDialog(
                        context: context,
                        builder: (c)
                        {
                          return ErrorDialog(
                            message: "You are offline!",
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
                        return AlertDialog(
                          content: Text("Need to topup load 100 or more"),
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
                                if(tlp!.isEmpty)
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> PickTLPScreen()));
                                }
                                else
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MyTLPScreen()));
                                }
                              },
                            ),
                          ],
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
                        message: "Account Need Validation",
                      );
                    }
                );
              }
            }
            if(index == 7)
            {
              //PakiPila
              if(isqueuervalidated)
              {
                if(double.parse(load) >= 100)
                {
                  if(isDriverAvailable)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiPilaScreen()));
                  }
                  else
                  {
                    showDialog(
                        context: context,
                        builder: (c)
                        {
                          return ErrorDialog(
                            message: "You are offline!",
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
                        return AlertDialog(
                          content: Text("Need to topup load 100 or more"),
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
                                if(tlp!.isEmpty)
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> PickTLPScreen()));
                                }
                                else
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MyTLPScreen()));
                                }
                              },
                            ),
                          ],
                        );
                      }
                  );
                }
              }
              else
              {
                {
                  showDialog(
                      context: context,
                      builder: (c)
                      {
                        return ErrorDialog(
                          message: "Account Need Validation",
                        );
                      }
                  );
                }

              }

            }
            if(index == 8)
            {
              //PakiProxy
              if(isqueuervalidated)
              {
                if(double.parse(load) >= 100)
                {
                  if(isDriverAvailable)
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiProxyScreen()));
                  }
                  else
                  {
                    showDialog(
                        context: context,
                        builder: (c)
                        {
                          return ErrorDialog(
                            message: "You are offline!",
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
                        return AlertDialog(
                          content: Text("Need to topup load 100 or more"),
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
                                if(tlp!.isEmpty)
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> PickTLPScreen()));
                                }
                                else
                                {
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MyTLPScreen()));
                                }
                              },
                            ),
                          ],
                        );
                      }
                  );
                }
              }
              else
              {
                {
                  showDialog(
                      context: context,
                      builder: (c)
                      {
                        return ErrorDialog(
                          message: "Account Need Validation",
                        );
                      }
                  );
                }

              }
            }
            if(index == 9)
            {
              //history
              Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Icon(
                    iconData,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
