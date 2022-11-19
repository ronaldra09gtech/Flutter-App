import 'package:flutter/material.dart';
import 'package:plmclient/queuer/authentication/register.dart';
import 'package:plmclient/queuer/authentication/verify_email.dart';

import 'login.dart';


class AuthScreen1 extends StatefulWidget {
  const AuthScreen1({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen1> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.lightBlueAccent,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            "Queuer",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Lobster",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.white,),
                text: "Register",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.white,),
                text: "Login",
              ),
            ],
            indicatorColor: Colors.white38,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
              )
          ),
          child: TabBarView(
            children: [
              RegisterScreen(),
              LoginScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
