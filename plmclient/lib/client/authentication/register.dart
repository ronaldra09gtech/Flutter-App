import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/home_Screen.dart';
import 'package:plmclient/client/widgets/customTextField.dart';
import 'package:plmclient/client/widgets/error_dialog.dart';
import 'package:plmclient/client/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'authScreen1.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  bool tlpExist = true;


  Future<void> formValidation() async
  {
    if(tlpExist){
      if(passwordController.text == confirmPasswordController.text)
      {
        if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty)
        {
          //start uploading image
          // showDialog(
          //     context: context,
          //     builder: (c)
          //     {
          //       return LoadingDialog(
          //         message: "Register Account",
          //       );
          //     }
          // );
          //
          // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          // fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("pilamokoclient").child(fileName);
          // fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          // fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          // await taskSnapshot.ref.getDownloadURL().then((url) {
          //   pilamokotlpImageUrl = url;
          //
          //   //save info to firebase
          // });

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
      readDataAndSetDataLocally(currentUser!).then((value){
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("pilamokoclient")
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

  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("pilamokoclient")
        .doc(currentUser.email)
        .set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "photoUrl" : "",
      "phone" : phoneController.text.trim(),
      "userType": "client",
      "queuer" : "",
      "loadWallet" : 0,
      "status" : "approved",
      "userCart": ['garbageValue'],
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("userType", "client");
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);

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
            const SizedBox(height: 10,),
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
