import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/authentication/authScreen.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/home_Screen.dart';
import 'package:plmclient/tlp/mainScreens/home_Screen.dart';

import '../../main.dart';
import '../../merchat/mall/mainScreens/home_Screen.dart';
import '../../merchat/market/mainScreens/home_Screen.dart';
import '../../merchat/resto/mainScreens/home_Screen.dart';
import '../../queuer/splashScreen/splashScreen.dart';


class MySplashScreenClient extends StatefulWidget {
  const MySplashScreenClient({Key? key}) : super(key: key);

  @override
  _MySplashScreenClientState createState() => _MySplashScreenClientState();
}


class _MySplashScreenClientState extends State<MySplashScreenClient>
{

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
      //if user is login already
      if(firebaseAuth.currentUser != null){
        await FirebaseFirestore.instance.collection("pilamokoclient")
            .where("email", isEqualTo: firebaseAuth.currentUser!.email)
            .get()
            .then((snapshot) async {
          if(snapshot.size > 0){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
          }
          else {
            await FirebaseFirestore.instance.collection("pilamokoqueuer")
                .where("pilamokoqueuerEmail", isEqualTo: firebaseAuth.currentUser!.email)
                .get()
                .then((snapshot) async {
              if(snapshot.size > 0){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreenQueuer()));
              }
              else {
                await FirebaseFirestore.instance.collection("pilamokotlp")
                    .where("email", isEqualTo: firebaseAuth.currentUser!.email)
                    .get()
                    .then((snapshot)async{
                  if(snapshot.size > 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenTLP()));
                  }
                  else {
                    await FirebaseFirestore.instance.collection("pilamokoseller")
                        .where("pilamokosellerEmail", isEqualTo: firebaseAuth.currentUser!.email)
                        .get()
                        .then((snapshot) async {
                      if(snapshot.size > 0){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenEresto()));
                      }
                      else {
                        await FirebaseFirestore.instance.collection("pilamokoemarket")
                            .where("pilamokoemarketEmail", isEqualTo: firebaseAuth.currentUser!.email)
                            .get()
                            .then((snapshot) async {
                          if(snapshot.size > 0){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenEmarket()));
                          }
                          else{
                            await FirebaseFirestore.instance.collection("pilamokoemall")
                                .where("pilamokoemallEmail", isEqualTo: firebaseAuth.currentUser!.email)
                                .get()
                                .then((snapshot) {
                              if(snapshot.size > 0){
                                Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenEmall()));
                              }
                            });
                          }
                        });
                      }
                    });
                  }
                });
              }
            });
          }
        });
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
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
    return Material(
      child: Container(
        child: Image.asset("images/PAKI QUEUE.jpg", fit: BoxFit.cover,),
      ),
    );
  }
}
