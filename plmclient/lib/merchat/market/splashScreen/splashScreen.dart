import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plmclient/merchat/market/authentication/authScreen.dart';
import 'package:plmclient/merchat/market/global/global.dart';
import 'package:plmclient/merchat/market/mainScreens/home_Screen.dart';

import '../../../main.dart';

class MySplashScreenMarket extends StatefulWidget {
  const MySplashScreenMarket({Key? key}) : super(key: key);

  @override
  _MySplashScreenMarketState createState() => _MySplashScreenMarketState();
}


class _MySplashScreenMarketState extends State<MySplashScreenMarket>
{

  startTimer()
  {
    Timer(const Duration(seconds: 3), () async {
      //if user is login already
      if(firebaseAuth.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreenEmarket()));
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
        child: Image.asset("images/PALENG QUE.jpg", fit: BoxFit.cover,),
      ),
    );
  }
}
