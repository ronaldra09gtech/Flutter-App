import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plmclient/merchat/resto/authentication/authScreen.dart';
import 'package:plmclient/merchat/resto/global/global.dart';
import 'package:plmclient/merchat/resto/mainScreens/home_Screen.dart';

import '../../../main.dart';


class MySplashScreenResto extends StatefulWidget {
  const MySplashScreenResto({Key? key}) : super(key: key);

  @override
  _MySplashScreenRestoState createState() => _MySplashScreenRestoState();
}


class _MySplashScreenRestoState extends State<MySplashScreenResto>
{

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
      //if user is login already
      if(firebaseAuth.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreenEresto()));
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
        child: Image.asset("images/RESTO.jpg", fit: BoxFit.cover,),
      ),
    );
  }
}
