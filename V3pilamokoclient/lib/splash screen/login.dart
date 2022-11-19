import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v3pilamokoemall/screens/services/services_screen.dart';
import '../global/global.dart';
import '../screens/homescreen/homescreen.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';
import 'forgot_password.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool value = false;

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
          return const LoadingDialog(
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
    await FirebaseFirestore.instance.collection("pilamokoclient")
        .doc(currentUser.email)
        .get()
        .then((snapshot) async {
      if(snapshot.exists)
      {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", snapshot.data()!["email"]);
        await sharedPreferences!.setString("name", snapshot.data()!["name"]);
        await sharedPreferences!.setString("phone", snapshot.data()!["phone"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);
        List<String> userCartList = snapshot.data()!['userCart'].cast<String>();
        await sharedPreferences!.setStringList("userCart", userCartList);
        loadWallet = double.parse(snapshot.data()!['loadWallet'].toString());

        address = snapshot.data()!['address'].toString();
        zone = snapshot.data()!['zone'].toString();
        queuer = snapshot.data()!['queuer'].toString();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ServiceScreen()));
      }
      else
      {
        firebaseAuth.signOut();
        Navigator.pop(context);

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



  Future<bool?> showWarning(BuildContext context) async =>  showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to exit app?"),
        actions: [
          TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text("Yes")
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")
          ),
        ],
      )
  );

  final spinKit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.red : Colors.green,
        ),
      );
    },
  );

  bool _secureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // data being hashed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.blueAccent.shade400,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Row(
                    children: [
                      Image.asset("assets/images/logo.PNG",
                        height: 60,
                        width: 60,
                      ),
                      const Text("Pilamoko",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const SizedBox(height: 75),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      fillColor: Colors.white,
                      filled: true  ,
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Colors.black
                          )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ),
                    obscureText: _secureText,
                    decoration: InputDecoration(
                        filled: true ,
                        fillColor: Colors.white,
                        focusColor: Colors.black,
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.black,),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye,
                            color: Colors.black,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return ForgotPasswordPage();
                          },
                          ),
                          );
                        },
                        child: const Text("Forgot Password?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,),
                      const Text("Remember Password?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      Checkbox(
                        value: value,
                        onChanged: (value) {
                          setState(() {
                            this.value = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (c)=>  const ServiceScreen()));
                      formValidation();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueAccent.shade400
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text("Sign In",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent.shade400,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
