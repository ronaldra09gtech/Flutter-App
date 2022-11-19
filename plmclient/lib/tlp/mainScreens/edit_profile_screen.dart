import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../global/global.dart';
import '../mainScreens/home_Screen.dart';
import '../widgets/customTextField.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/simple_app_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zoneController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String pilamokotlpImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Updating",
            );
          });
      saveDataToFirestore2();
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreenTLP()));

    } else {
      if (emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          locationController.text.isNotEmpty &&
          zoneController.text.isNotEmpty) {
        showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(
                message: "Updating",
              );
            });
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        fStorage.Reference reference = fStorage.FirebaseStorage.instance
            .ref()
            .child("pilamokotlp")
            .child(fileName);
        fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          pilamokotlpImageUrl = url;

          //save info to firebase
          saveDataToFirestore();
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreenTLP()));
        });
      }
    }
  }

  Future saveDataToFirestore2() async {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid")!)
        .update({
      "pilamokotlpEmail": emailController.text.trim(),
      "pilamokotlpName": nameController.text.trim(),
      "pilamokotlpAvatarUrl": sharedPreferences!.getString("photoUrl"),
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "zone": zoneController.text.trim(),
    }).then((value){
      FirebaseFirestore.instance
          .collection("zone")
          .doc(zoneController.text.trim())
          .collection("tlp")
          .doc(sharedPreferences!.getString("uid")!)
          .set({
        "pilamokotlpUID": sharedPreferences!.getString("uid")!,
        "pilamokotlpEmail": emailController.text.trim(),
        "pilamokotlpName": nameController.text.trim(),
        "pilamokotlpAvatarUrl": pilamokotlpImageUrl,
        "phone": phoneController.text.trim(),
        "address": completeAddress,
        "zone": zoneController.text.trim(),
        "status": "approved",
        "earning": 0.0,
        "loadWallet": 0.0,
        "lat": position!.latitude,
        "lng": position!.longitude,
      });
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("email", emailController.text.trim());
    await sharedPreferences!.setString("name", nameController.text.trim());
    setState(() {
      imageXFile=null;
    });
  }

  Future saveDataToFirestore() async {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid")!)
        .update({
      "pilamokotlpEmail": emailController.text.trim(),
      "pilamokotlpName": nameController.text.trim(),
      "pilamokotlpAvatarUrl": pilamokotlpImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "zone": zoneController.text.trim(),
    }).then((value){
      FirebaseFirestore.instance
          .collection("zone")
          .doc(zoneController.text.trim())
          .collection("tlp")
          .doc(sharedPreferences!.getString("uid")!)
          .set({
        "pilamokotlpUID": sharedPreferences!.getString("uid")!,
        "pilamokotlpEmail": emailController.text.trim(),
        "pilamokotlpName": nameController.text.trim(),
        "pilamokotlpAvatarUrl": pilamokotlpImageUrl,
        "phone": phoneController.text.trim(),
        "address": completeAddress,
        "zone": zoneController.text.trim(),
        "status": "approved",
        "earning": 0.0,
        "loadWallet": 0.0,
        "lat": position!.latitude,
        "lng": position!.longitude,
      });
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("email", emailController.text.trim());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", pilamokotlpImageUrl);
    setState(() {
      pilamokotlpImageUrl="";
    });
  }


  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
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
    zoneController.text = '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea} ${pMark.administrativeArea}';
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    nameController.text = sharedPreferences!.getString("name")!;
    emailController.text = email;
    phoneController.text = phone;
    locationController.text = address;
    zoneController.text = zone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "",),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      InkWell(
                          onTap: () {
                            _getImage();
                          },
                          child: imageXFile == null
                              ? CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.20,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                                sharedPreferences!.getString("photoUrl")!
                            ),
                          )
                              : CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.20,
                            backgroundColor: Colors.white,
                            backgroundImage: imageXFile == null
                                ? null
                                : FileImage(File(imageXFile!.path)),
                            child: imageXFile == null
                                ? Icon(
                              Icons.add_photo_alternate,
                              size: MediaQuery.of(context).size.width * 0.20,
                              color: Colors.grey,
                            )
                                : null,

                          )
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Full Name"),
                  ),
                ),
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hintText: "Name",
                  isObsecre: false,
                ),
                const SizedBox(
                  height: 15,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Email"),
                  ),
                ),
                CustomTextField(
                  data: Icons.mail,
                  controller: emailController,
                  hintText: email,
                  isObsecre: false,
                ),
                const SizedBox(
                  height: 15,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Phone Nmber"),
                  ),
                ),
                CustomTextField(
                  data: Icons.phone,
                  controller: phoneController,
                  hintText: phone,
                  isObsecre: false,
                ),
                const SizedBox(
                  height: 15,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Address"),
                  ),
                ),
                CustomTextField(
                  data: Icons.location_on,
                  controller: locationController,
                  hintText: address,
                  isObsecre: false,
                ),
                const SizedBox(
                  height: 15,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Zone"),
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: zoneController,
                  obscureText: false,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    hintText: "zone",
                  ),
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
                    "Save",
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

        ),
      ),
    );
  }
}
