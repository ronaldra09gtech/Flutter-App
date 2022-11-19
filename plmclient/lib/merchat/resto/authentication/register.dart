import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plmclient/merchat/resto/global/global.dart';
import 'package:plmclient/merchat/resto/mainScreens/home_Screen.dart';
import 'package:plmclient/merchat/resto/widgets/customTextField.dart';
import 'package:plmclient/merchat/resto/widgets/error_dialog.dart';
import 'package:plmclient/merchat/resto/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String tlp = "";
  String? tlpExist = "";



  getTlpData(){
    FirebaseFirestore.instance
        .collection("zone")
        .doc(zone)
        .get().then((snap) {
      tlpExist = snap.data()!['status'].toString();
    });

  }


  Future<void> formValidation() async
  {
    {
      if(tlpExist=="open")
      {
        if(passwordController.text == confirmPasswordController.text)
        {
          if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && phoneController.text.isNotEmpty)
          {
            //start uploading image
            showDialog(
                context: context,
                builder: (c)
                {
                  return LoadingDialog(
                    message: "Register Account",
                  );
                }
            );
            authenticatepilamokotlpAndSignUp();
          }
          else
          {
            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "Please write the complete info for Registration!.",
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
                  message: "Password do not match!.",
                );
              }
          );
        }
      }
      else
      {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Theres no Tlp in $zone",
              );
            });
      }
    }
  }

  void authenticatepilamokotlpAndSignUp() async
  {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: error.message.toString(),
            );
          }
      );
    });

    if(currentUser != null)
    {
      saveDataToFirestore(currentUser!).then((value){
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreenEresto());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("pilamokoseller").doc(currentUser.uid).set({
      "pilamokosellerUID": currentUser.uid,
      "pilamokosellerEmail": currentUser.email,
      "phone" : phoneController.text.trim(),
      "status" : "approved",
      "userType" : "eresto",
      "zone" : zone,
      "earning": 0.0,
    }).then((value){
      FirebaseFirestore.instance
          .collection("seller")
          .doc(currentUser.uid)
          .set({
        "pilamokosellerUID": currentUser.uid,
        "pilamokosellerEmail": currentUser.email,
        "phone": phoneController.text.trim(),
        "zone": zone,
        "status": "approved",
        "earning": 0.0,
      });
    });

    //save data locally
    await sharedPreferences!.setString("uid", currentUser.uid );
    await sharedPreferences!.setString("userType", "eresto" );
    await sharedPreferences!.setString("email", currentUser.email.toString() );


  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 50,),
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
            const SizedBox(height: 30,),
            ElevatedButton(
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: ()
              {
                formValidation();
              },
            ),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

}
