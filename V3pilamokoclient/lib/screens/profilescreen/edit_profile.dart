import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:v3pilamokoemall/screens/profilescreen/profile_layout.dart';

import '../../global/global.dart';
import '../../splash screen/splash_screen.dart';
import '../../widgets/loading_dialog.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zoneController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String ImageUrl = "";

  bool onchange = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = sharedPreferences!.getString("name")!;
    phoneController.text = sharedPreferences!.getString("phone")!;
    locationController.text = address;
    zoneController.text = zone;
  }

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) {
        return const LoadingDialog(message: "",);
      }
    );
    LocationPermission permission;permission = await Geolocator.requestPermission();
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
    Navigator.pop(context);
  }


  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) {
            return const LoadingDialog(
              message: "Updating",
            );
          });
      saveWithOutImage();
    }
    else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) {
            return const LoadingDialog(
              message: "Updating",
            );
          });
      saveWithImage();
    }
  }

  saveWithImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoclient")
        .child(fileName);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      ImageUrl = url;
      //save info to firebase
      saveDataToFirestore();
    });
  }

  saveDataToFirestore() async {
    await FirebaseFirestore.instance
        .collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email")!)
        .update({
      "name": nameController.text.trim(),
      "photoUrl": ImageUrl,
      "phone": phoneController.text.trim(),
      "address": locationController.text.trim(),
      "zone": zoneController.text.trim(),
    }).whenComplete(() async {
      await sharedPreferences!.setString("photoUrl", ImageUrl);
      await sharedPreferences!.setString("phone", phoneController.text.trim());
      await sharedPreferences!.setString("name", nameController.text);
      Fluttertoast.showToast(msg: "Profile Has been Edited");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> SideBarLayoutProfile()));
    });
  }

  saveWithOutImage() async {
    await FirebaseFirestore.instance
        .collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email")!)
        .update({
      "name": nameController.text.trim(),
      "photoUrl": ImageUrl,
      "phone": phoneController.text.trim(),
      "address": locationController.text.trim(),
      "zone": zoneController.text.trim(),
    }).whenComplete(() async {
      await sharedPreferences!.setString("name", nameController.text);
      await sharedPreferences!.setString("phone", phoneController.text.trim());
      Fluttertoast.showToast(msg: "Profile Has been Edited");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> SideBarLayoutProfile()));
    });
  }

  Future<bool?> showWarning(BuildContext context) async =>  showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Do you want to leave without saving"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Dismiss")
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")
          ),
        ],
      )
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(onchange) {
          final shouldPop = await showWarning(context);
          return shouldPop ?? true ;
        }else {
          return true;
        }

      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
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
                            )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                      child: const Text("Note: Tap the picture to change profile picture.")
                  ),
                  const SizedBox(height: 50),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: false,
                      controller: nameController,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                      onChanged: (value){
                        setState(() {
                          onchange = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                                color: Colors.black
                            ),
                            obscureText: false,
                            controller: phoneController,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                    color: Colors.black
                                ),
                                labelText: "Phone Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                            onChanged: (value){
                              setState(() {
                                onchange = true;
                              });
                            },
                          ),
                        ),
                        Positioned(
                            bottom:  26,
                            right: 18,
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: const BoxDecoration(
                              ),
                              child: Icon(Icons.verified,
                                  color: Colors.blueAccent.shade400),
                            )
                        )
                      ]
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: false,
                      enabled: false,
                      maxLines: 2,
                      controller: locationController,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                      onChanged: (value){
                        setState(() {
                          onchange = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: TextFormField(
                          style: const TextStyle(
                              color: Colors.black
                          ),
                          obscureText: false,
                          enabled: false,
                          controller: zoneController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                  color: Colors.black
                              ),
                              labelText: "Zone",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                          onChanged: (value){
                            setState(() {
                              onchange = true;
                            });
                          },
                        ),
                      ),
                      Positioned(
                          bottom:  26,
                          right: 18,
                          child: Container(
                            height: 17,
                            width: 17,
                            decoration: const BoxDecoration(
                            ),
                            child: Icon(Icons.verified,
                                color: Colors.blueAccent.shade400),
                          )
                      )
                    ],
                  ),
                  const Text("Note: We recommend to use the button below to get your accurate ADDRESS and ZONE base on your device, To help the rider locate you"),
                  const SizedBox(height: 40),
                  InkWell(
                    onTap: (){
                      getCurrentLocation();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueAccent.shade400
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text("Get My Current Location",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent.shade400,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: (){
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        formValidation();
                        // formValidation();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueAccent.shade400
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text("Save Changes",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent.shade400,
                            fontWeight: FontWeight.bold
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
    );
  }
}
