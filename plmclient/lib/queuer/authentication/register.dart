import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:plmclient/queuer/mainScreens/homescreen/bike_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/walker_homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import '../global/global.dart';
import '../mainScreens/homescreen/home_screen.dart';
import '../widgets/customTextField.dart';
import 'authScreen1.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  String? valueChoose;
  List listItem = [
    "Walking Queuer",
    "Queuer with Bike / Bike",
    "Queuer with Motorcycle",
    "Queuer with 4 Wheels",
  ];



  void facebook() => Fluttertoast.showToast(
    msg: "Facebook register is not yet available",
    fontSize: 15,
    gravity: ToastGravity.TOP,
  );

  void google() => Fluttertoast.showToast(
    msg: "Google register is not yet available",
    fontSize: 15,
    gravity: ToastGravity.TOP,
  );



  Future<void> formValidation() async {
    {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            phoneController.text.isNotEmpty && valueChoose!.isNotEmpty) {
          if (!emailController.text.contains("@")){
            showDialog(
                context: context,
                builder: (c) {
                  return ErrorDialog(
                    message: "Please enter valid email",
                  );
                });
          }
          else{
            //start uploading image
            showDialog(
                context: context,
                builder: (c) {
                  return LoadingDialog(
                    message: "Register Account",
                  );
                });
            authenticatepilamokotlpAndSignUp();
          }

        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Please write the complete info for Registration!.",
                );
              });
        }
      }
      else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Password do not match!.",
              );
            });
      }
    }
  }

  void authenticatepilamokotlpAndSignUp() async {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(context: context, builder: (c) {
        return ErrorDialog(
          message: error.message.toString(),
        );
      });
    });

    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
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
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(currentUser.email)
        .set({
      "pilamokoqueuerUID": currentUser.uid,
      "pilamokoqueuerEmail": currentUser.email,
      "pilamokoqueuerLicenseUrl": "",
      "pilamokoqueuerOrcrUrl": "",
      "pilamokoqueuerBillingUrl": "",
      "validID": "",
      "queuerType": valueChoose,
      "userType": "queuer",
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "isValidated": false,
      "earning": 0.0,
      "loadWallet": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    }).then((value){
      FirebaseFirestore.instance
          .collection("queuer")
          .doc(currentUser.email)
          .set({
        "pilamokotlpUID": currentUser.uid,
        "pilamokotlpEmail": currentUser.email,
        "pilamokoqueuerLicenseUrl": "",
        "pilamokoqueuerOrcrUrl": "",
        "pilamokoqueuerBillingUrl": "",
        "validID": "",
        "phone": phoneController.text.trim(),
        "address": completeAddress,
        "status": "approved",
        "earning": 0.0,
        "loadWallet": 0.0,
        "lat": position!.latitude,
        "lng": position!.longitude,
      });
    }).then((value){
      FirebaseFirestore.instance
          .collection("pilamokoQueuerAvailableDrivers")
          .doc(currentUser.email)
          .set({
        "email":currentUser.email,
        "lat": position!.latitude,
        "lng": position!.longitude,
        "status": "online",
      });
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("userType", "queuer");
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("queuerType", valueChoose!);

  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("pilamokoqueuer")
        .doc(currentUser.email)
        .get()
        .then((snapshot) async {
      if(snapshot.exists)
      {
        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> AuthScreen1()));
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Email Already Used",
              );
            });
      }
      else
      {
        saveDataToFirestore(currentUser);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone Number",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirmed Password",
                    isObsecre: true,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text("Queuer Type"),
                        ),
                        DropdownButton(
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
                      ],
                    ),
                  ),
                ],
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
    );
  }
}
