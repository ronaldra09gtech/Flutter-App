import 'package:flutter/material.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/splashScreen/splashScreen.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₱ " + previousRiderEarnings,
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),

              const Text(
                "Total Earnings ",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),

              const SizedBox(height: 40,),

              GestureDetector(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreenQueuer()));
                },
                child: const Card(
                  color: Colors.white54,
                  margin: EdgeInsets.symmetric(vertical: 40,horizontal: 120),
                  child: ListTile(
                    leading: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
