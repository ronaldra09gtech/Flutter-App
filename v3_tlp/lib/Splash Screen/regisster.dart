import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:v3_tlp/Splash%20Screen/privacyandpolicy.dart';
import 'dart:io';
import 'package:v3_tlp/Splash%20Screen/splash_screen.dart';
import 'package:v3_tlp/Splash%20Screen/termsandconditions.dart';
import '../Screens/TLP Main Screen/sidelayouthome.dart';
import '../global/global.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  Future<bool> _willPopCallback() async {
    exit(0);
  }

  Future<void> formValidation() async {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            phoneController.text.isNotEmpty ) {
          if (!emailController.text.contains("@")){
            showDialog(
                context: context,
                builder: (c) {
                  return const ErrorDialog(
                    message: "Please enter valid email",
                  );
                });
          }
          else{
            //start uploading image
            showDialog(
                context: context,
                builder: (c) {
                  return const LoadingDialog(
                    message: "Register Account",
                  );
                });
            authenticatepilamokotlpAndSignUp();
          }

        } else {
          showDialog(
              context: context,
              builder: (c) {
                return const ErrorDialog(
                  message: "Please write the complete info for Registration!.",
                );
              });
        }
      }
      else {
        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Password do not match!.",
              );
            });
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
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => const SideBarLayoutHome());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(currentUser.uid)
        .set({
      "pilamokotlpUID": currentUser.uid,
      "pilamokotlpEmail": currentUser.email,
      "pilamokotlpName": "",
      "phone": phoneController.text.trim(),
      "status": "approved",
      "zone": "",
      "photoUrl": "",
      "userType": "tlp",
      "earning": 0.0,
      "loadWallet": 0.0,
    });

    //save data locally
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("userType", "tlp");
    await sharedPreferences!.setString("name", "");
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("photoUrl", "");

  }
  bool rememberMe = false;
  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
    } else {
    }
  });

  bool isChecked = false;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (c) => const SplashScreen()));
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.black,)
                    ),
                  ),
                  const Text("Sign Up" , style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                  ),
                  Container(
                    height: 270,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage("assets/images/tlpreg.png",
                      ),
                        fit: BoxFit.fill
                      )
                    )
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      controller: phoneController,
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: false,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Phone Number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: false,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: isChecked,
                                  activeColor: Colors.blueAccent,
                                  tristate: true,
                                  onChanged: (newBool) {
                                    setState(() {
                                      isChecked = newBool!;
                                    });
                                  },
                              ),
                              const Text("I agree to Pilamoko's",),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const TermsAndConditions()));
                                },
                                child: const Text("Terms & Conditons",
                                  style: TextStyle(
                                    color: Color(0xFF262AAA),
                                    fontWeight: FontWeight.w500,
                                  ),),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("and"),
                              const SizedBox(width: 5,),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (c) => const PrivacyAndPolicy()));
                                },
                                child: const Text("Privacy Policy",
                                  style: TextStyle(
                                    color: Color(0xFF262AAA),
                                    fontWeight: FontWeight.w500,
                                  ),),
                              )
                            ],
                          ),
                        ],
                      ),


                    ],
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: (){
                      if(isChecked){
                        formValidation();
                      }
                      else {
                        showDialog(
                          context: context,
                          builder: (c){
                            return const ErrorDialog(message: "Please read ang check our Terms & Conditons",);
                          }
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueAccent.shade400
                          ),
                          color: Colors.blueAccent.shade400,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Text("Sign Up",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
