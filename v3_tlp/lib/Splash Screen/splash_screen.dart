import 'package:flutter/material.dart';
import 'package:v3_tlp/Splash%20Screen/regisster.dart';
import 'package:v3_tlp/Splash%20Screen/video_widget.dart';
import 'login.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.all(10),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 70),
                    const Text("The Pilamoko Top-up Load",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const Text("Providing System",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 40),
                    Image.asset("assets/images/logo.PNG",
                      height: 250,
                      width: 250,
                    ),
                    const SizedBox(height: 100),
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
