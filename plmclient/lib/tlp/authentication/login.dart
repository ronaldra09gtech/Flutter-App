import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:plmclient/queuer/splashScreen/splashScreen.dart';

import '../../client/splashScreen/splashScreen.dart';
import '../../main.dart';
import '../../merchat/mall/splashScreen/splashScreen.dart';
import '../../merchat/market/splashScreen/splashScreen.dart';
import '../../merchat/resto/splashScreen/splashScreen.dart';
import '../authentication/authScreen.dart';
import '../authentication/forgot_password.dart';
import '../global/global.dart';
import '../mainScreens/home_Screen.dart';
import '../widgets/customTextField.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();


  void apple() => Fluttertoast.showToast(
    msg: "Apple register is not yet available",
    fontSize: 15,
    gravity: ToastGravity.TOP,
  );

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

  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      //login
      loginNow();
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please write email/password.",
            );
          }
      );
    }
  }


  loginNow() async
  {
    showDialog(
        context: context,
        builder: (c)
        {
          return LoadingDialog(
            message: "Checking Credentials.",
          );
        }
    );

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth){
      currentUser = auth.user!;
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
      readDataAndSetDataLocally(currentUser!);
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async
  {
    await FirebaseFirestore.instance.collection("pilamokotlp")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if(snapshot.exists)
      {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", snapshot.data()!["pilamokotlpEmail"]);
        await sharedPreferences!.setString("userType", snapshot.data()!["userType"]);
        await sharedPreferences!.setString("name", snapshot.data()!["pilamokotlpName"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["pilamokotlpAvatarUrl"]);

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreenTLP()));
      }
      else
      {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "No record found.",
              );
            }
        );
      }
    });
  }

  googleLogin() async
  {
    final newuser = await _googleSignIn.signIn();
    final googleauth = await newuser!.authentication;
    final creds = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(creds);
    print(googleName);
    print(googleId);
    print(googleEmail);
    googleName = newuser.displayName.toString();
    googleId = newuser.id.toString();
    googlePhotoUrl = newuser.photoUrl.toString();
    googleEmail = newuser.email.toString();
    readDataAndSetDataLocallyGoogle(googleName, googleEmail, googleId, googlePhotoUrl);
  }

  Future readDataAndSetDataLocallyGoogle(String googleName, String googleEmail, String googleID, String googlePhotoUrl) async
  {
    await FirebaseFirestore.instance.collection("pilamokotlp")
        .doc(googleEmail)
        .get()
        .then((snapshot) async {
      if(snapshot.exists)
      {
        await sharedPreferences!.setString("uid", googleID);
        await sharedPreferences!.setString("email", snapshot.data()!["pilamokotlpEmail"]);
        await sharedPreferences!.setString("name", snapshot.data()!["pilamokotlpName"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["pilamokotlpAvatarUrl"]);

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenTLP()));
      }
      else
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
                message: "No record found.",
              );
            }
        );
      }
    });
  }

  String status = "Unknown";
  final _connectivity = Connectivity();
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  StreamSubscription<ConnectivityResult>? _streamSubscription;

  @override
  void initState() {
    initialisedConnectivity();
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {updateConnectivityStatus(event);
    });
    super.initState();
  }

  initialisedConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    result = await _connectivity.checkConnectivity();
    updateConnectivityStatus(result);
  }

  updateConnectivityStatus(ConnectivityResult result){
    connectivityResult = result;
    switch(result){
      case ConnectivityResult.none:
        status = "Not Connected";
        break;
      case ConnectivityResult.wifi:
        status = "Connected to Wifi";
        break;
      case ConnectivityResult.mobile:
        status = "Connected to Mobile Data";
        break;
      default:
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [

          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset(
                "images/TLP login.png",
                height: 250,
              ),
            ),
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
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword(),),);
          },
            child: const Text(
              ' Forgot Password ?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 30,),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            onPressed: ()
            {
              formValidation();
            },
          ),
          const SizedBox(height: 30,),

          // Text('Sign in with',
          //   style: TextStyle(fontSize: 15.0, color: Colors.white),),
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 20.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       //google sign in
          //       TextButton(
          //         onPressed: () async {
          //           googleLogin();
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

          Text("Type of User",
            style: TextStyle(
                color: Colors.white
            ),

          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Client"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreenClient()));
                  },
                ),
                ElevatedButton(
                  child: Text("Merchant"),
                  onPressed: (){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                const Text(
                                  'Choose Merchant',
                                  style: TextStyle(
                                      fontSize: 45
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        child: const Text('E-Mall'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreenMall()));
                                        }
                                    ),
                                    ElevatedButton(
                                        child: const Text('E-Restaurant'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreenResto()));
                                        }
                                    ),
                                    ElevatedButton(
                                        child: const Text('Paleng Que'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreenMarket()));
                                        }
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                ElevatedButton(
                  child: Text("Queuer"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreenQueuer()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

