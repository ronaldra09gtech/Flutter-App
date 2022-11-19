import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../global/global.dart';
import '../../widgets/loading_dialog.dart';


class ZoneBody extends StatefulWidget {
  const ZoneBody({Key? key}) : super(key: key);



  @override
  State<ZoneBody> createState() => _ZoneBodyState();
}


class _ZoneBodyState extends State<ZoneBody> {

  String textHolder = "Acitvate to Unlock Zone";
  String textHolder1 = "Activate Zone";
  String textHolder2 = "Active";

  getCurrentLocation() async {

    LocationPermission permission; permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).whenComplete((){
      setState((){
        textHolder1 = "Register Zone";
      });
    });

    print(permission.toString());

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];
    setState((){
      zone = '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea} ${pMark.administrativeArea}';
      textHolder = '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}';
      completeAddress = '${pMark.street}, ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}';
    });
    print(zone);
    print(completeAddress);
    Navigator.pop(context);
  }

  checkZoneIfAlreadyCreated() async {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (c)
        {
          return const LoadingDialog(
            message: "",
          );
        }
    );
    await FirebaseFirestore.instance
        .collection("zone")
        .doc(zone)
        .get()
        .then((snap) async {
          if(snap.exists){
            await FirebaseFirestore.instance
                .collection("pilamokotlp")
                .doc(sharedPreferences!.getString("uid"))
                .update({
              "zone": zone,
            }).whenComplete((){
              Fluttertoast.showToast(
                  msg: "Zone Activation Success",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP_RIGHT,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
              );
              setState(() {
                textHolder1 = "Activate Zone";
              });
              Navigator.pop(context);
            });
          }
          else{
            registerzone();
          }
    });
  }

  registerzone()async{
    String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    String currentDateTime = DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(currentTime)));
    await FirebaseFirestore.instance
        .collection("zone")
        .doc(zone)
        .set({
      "zone": zone,
      "status": "open",
      "dateOpened": currentDateTime,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection("pilamokotlp")
          .doc(sharedPreferences!.getString("uid"))
          .update({
        "zone": zone,
      }).whenComplete((){
        Fluttertoast.showToast(
            msg: "Zone Activation Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        setState(() {
          textHolder1 = "Change your Zone";
        });
        Navigator.pop(context);
      });
    });
  }

  void clickFunction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c)
        {
          return const LoadingDialog(
            message: "",
          );
        }
    );
    getCurrentLocation();
    setState((){
      textHolder1 = "Pending";
    });

  }

  getTlpData()async
  {
    await FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap){
          if(snap.exists){
            setState(() {
              zone = snap.data()!['zone'].toString();
              textHolder = zone;
              textHolder1 = "Change your Zone";
            });
          }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTlpData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 70,
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Your Zone",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueAccent.shade400
                  ),
                ),
                const SizedBox(height: 38),
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.blueAccent.shade400,
                    ),
                  ),
                  child: Text(textHolder),
                ),
                const SizedBox(height: 30,),
                Column(
                  children: [
                    InkWell(
                      onTap: textHolder1 == "Activate Zone" ? clickFunction : checkZoneIfAlreadyCreated,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white
                            ),
                            color: Colors.blueAccent.shade400,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(textHolder1,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100,),
                const Text("Take Note!"),
                const SizedBox(height: 5),
                const Text("Please ensure your current location to unlock your prospective zone to activate"),
                const SizedBox(height: 5),
                const Text("Wait for the Approval of the Admin"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
