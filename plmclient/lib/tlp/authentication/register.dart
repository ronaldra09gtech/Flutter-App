import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../authentication/authScreen1.dart';
import '../mainScreens/home_Screen.dart';
import '../widgets/customTextField.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import '../global/global.dart';
import 'google_registration_screen.dart';

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
            phoneController.text.isNotEmpty ){
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

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        saveDataToZone(currentUser!);
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreenTLP());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToZone(User currentUser) async {
    FirebaseFirestore.instance

          .collection("tlp")
          .doc(currentUser.uid)
          .set({
        "pilamokotlpUID": currentUser.uid,
        "pilamokotlpEmail": currentUser.email,
        "phone": phoneController.text.trim(),
        "status": "approved",
        "earning": 0.0,
        "loadWallet": 0.0,
      });
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(currentUser.uid)
        .set({
      "pilamokotlpUID": currentUser.uid,
      "pilamokotlpEmail": currentUser.email,
      "phone": phoneController.text.trim(),
      "status": "approved",
      "userType": "tlp",
      "earning": 0.0,
      "loadWallet": 0.0,
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("userType", "tlp");
    await sharedPreferences!.setString("email", currentUser.email.toString());

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
            // Text('Or Sign up with',
            //   style: TextStyle(fontSize: 15.0, color: Colors.white),),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 20.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       //google sign in
            //       TextButton(
            //         onPressed: () async {
            //           google();
            //         },
            //         style: TextButton.styleFrom(
            //             side: BorderSide(width: 1, color: Colors.grey),
            //             minimumSize: Size(40,40),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20)
            //             ),
            //             primary: Colors.white,
            //             backgroundColor: Colors.red
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(
            //               CommunityMaterialIcons.google_plus,
            //             ),
            //             Text(
            //                 "Google"
            //             ),
            //             SizedBox(
            //               width: 5,
            //             ),
            //           ],
            //         ),
            //       ),
            //
            //       //facebook sign in
            //       TextButton(
            //         onPressed: ()  {
            //           facebook();
            //         },
            //         style: TextButton.styleFrom(
            //           side: BorderSide(width: 1, color: Colors.grey),
            //           minimumSize: Size(40,40),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(20)
            //           ),
            //           primary: Colors.white,
            //           backgroundColor: Colors.blue,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Icon(
            //               CommunityMaterialIcons.facebook,
            //             ),
            //             Text(
            //                 "Facebook"
            //             ),
            //             SizedBox(
            //               width: 5,
            //             ),
            //           ],
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: (){
            //           apple();
            //         },
            //         style: TextButton.styleFrom(
            //             side: BorderSide(width: 1, color: Colors.grey),
            //             minimumSize: Size(40,40),
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20)
            //             ),
            //             primary: Colors.white,
            //             backgroundColor: Colors.black
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(
            //               CommunityMaterialIcons.apple,
            //             ),
            //             Text(
            //                 "Apple ID"
            //             ),
            //             SizedBox(
            //               width: 5,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
