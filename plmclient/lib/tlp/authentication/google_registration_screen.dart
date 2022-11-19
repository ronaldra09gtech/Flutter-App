import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../mainScreens/home_Screen.dart';
import '..//widgets/customTextField.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import '../global/global.dart';
import 'authScreen.dart';

class GoogleRegistrationScreen extends StatefulWidget {
  @override
  _GoogleRegistrationScreenState createState() => _GoogleRegistrationScreenState();
}

class _GoogleRegistrationScreenState extends State<GoogleRegistrationScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Position? position;
  List<Placemark>? placeMarks;

  String pilamokotlpImageUrl = "";
  String completeAddress = "";
  String zzone = "";

  @override
  void initState() {
    super.initState();

    nameController.text = googleName;
    emailController.text = googleEmail;
  }

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
    '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
    zzone = '${pMark.locality}, ${pMark.subAdministrativeArea}';
    print(zzone);
  }

  Future<void> formValidation() async {
    if (emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        locationController.text.isNotEmpty) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Register Account",
            );
          });
      FirebaseFirestore.instance
          .collection("zone")
          .doc(zzone)
          .set({
        "zone": zzone,
        "status": "open",
        "dateOpened": currentDateTime,
      }).then((value) async {
        await FirebaseFirestore.instance.collection("pilamokotlp")
            .doc(googleEmail)
            .get()
            .then((snapshot) async {
          if(snapshot.exists)
          {
            firebaseAuth.signOut();
            _googleSignIn.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> AuthScreen()));
            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "Data Already Exist.",
                  );
                }
            );
          }
          else
          {
            saveDataToFirestore(googleName, googleEmail, googleId, googlePhotoUrl);
          }
        });
      });
      Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreenTLP());
      Navigator.pushReplacement(context, newRoute);
    }
    else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please Fill all Fields",
            );
          });
    }

  }


  Future saveDataToFirestore(String googleName, String googleEmail, String googleID, String googlePhotoUrl) async
  {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(googleEmail)
        .set({
      "pilamokotlpUID": googleID,
      "pilamokotlpEmail": googleEmail,
      "pilamokotlpName": googleName,
      "pilamokotlpAvatarUrl": googlePhotoUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "zone": zzone,
      "status": "approved",
      "earning": 0.0,
      "loadWallet": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", googleID);
    await sharedPreferences!.setString("email", googleEmail);
    await sharedPreferences!.setString("name", googleName);
    await sharedPreferences!.setString("photoUrl", googlePhotoUrl);
    Fluttertoast.showToast(msg: "Registration Successful.");

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
        automaticallyImplyLeading: false,
        title: const Text(
          "TLP",
          style: TextStyle(
            fontSize: 50,
            color: Colors.white,
            fontFamily: "Lobster",
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.20,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                googlePhotoUrl
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    enabled: false,
                    controller: nameController,
                    obscureText: false,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Name",
                    ),
                  ),
                ),

                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    enabled: false,
                    controller: emailController,
                    obscureText: false,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Email",
                    ),
                  ),
                ),
                CustomTextField(
                  data: Icons.phone,
                  controller: phoneController,
                  hintText: "Phone Number",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.my_location,
                  controller: locationController,
                  hintText: "Location",
                  isObsecre: false,
                  enabled: false,
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "Get my Current Location",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      getCurrentLocation();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  onPressed: () {
                    formValidation();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
