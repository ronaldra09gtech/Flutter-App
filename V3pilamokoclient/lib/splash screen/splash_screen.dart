import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/splash%20screen/register.dart';
import 'package:v3pilamokoemall/splash%20screen/video_widget.dart';

import '../global/global.dart';
import '../screens/homescreen/homescreen.dart';
import '../screens/services/services_screen.dart';
import 'login.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
      //if user is login already
      if(firebaseAuth.currentUser != null){
        await FirebaseFirestore.instance.collection("pilamokoclient")
            .doc(sharedPreferences!.getString("email")!).get().then((snapshot) {
              setState(() {
                loadWallet = double.parse(snapshot.data()!['loadWallet'].toString());
                address = snapshot.data()!['address'].toString();
                zone = snapshot.data()!['zone'].toString();
                queuer = snapshot.data()!['queuer'].toString();
              });
        }).whenComplete((){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> ServiceScreen()));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget> [
          Container(
            color: Colors.blueAccent.shade400.withOpacity(1),
            child: const Opacity(
                opacity: 0.6,
                child: VideoWidget()),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/images/logo.PNG",
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 20),
                        const Text("The Pilamoko",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                    InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) => const RegisterScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
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
                        child: const Text("Get Started & Sign Up!",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
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
                        child: const Text("Already have an account?",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
