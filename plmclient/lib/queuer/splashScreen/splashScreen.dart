import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plmclient/queuer/authentication/authScreen.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/bike_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/home_screen.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/walker_homescreen.dart';

import '../../main.dart';

class MySplashScreenQueuer extends StatefulWidget {
  const MySplashScreenQueuer({Key? key}) : super(key: key);

  @override
  _MySplashScreenQueuerState createState() => _MySplashScreenQueuerState();
}


class _MySplashScreenQueuerState extends State<MySplashScreenQueuer>
{

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
      //if user is login already
      if(firebaseAuth.currentUser != null){
        if(sharedPreferences!.getString("queuerType")!.toString() == "Walking Queuer"){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerHomeScreen()));
        }
        else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Bike / Bike"){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> BikerHomeScreen()));
        }
        else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Motorcycle" || sharedPreferences!.getString("queuerType")!.toString() == "Queuer with 4 Wheels"){
          Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
        }
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
        child: Image.asset("images/QUEUER.jpg", fit: BoxFit.cover,),
      ),
    );
  }
  }

