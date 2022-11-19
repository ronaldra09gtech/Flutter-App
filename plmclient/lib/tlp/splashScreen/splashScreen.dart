import 'dart:async';

import 'package:flutter/material.dart';

import '../../main.dart';
import '../authentication/authScreen.dart';
import '../global/global.dart';
import '../mainScreens/home_Screen.dart';


class MySplashScreenTLP extends StatefulWidget {
  const MySplashScreenTLP({Key? key}) : super(key: key);

  @override
  _MySplashScreenTLPState createState() => _MySplashScreenTLPState();
}


class _MySplashScreenTLPState extends State<MySplashScreenTLP>
{

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
      //if user is login already
      if(firebaseAuth.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenTLP()));
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
        child: Image.asset("images/TLP.jpg", fit: BoxFit.cover,),
      ),
    );
  }
}
