import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/profilescreen/edit_profile.dart';
import '../../global/global.dart';
import '../../splash screen/change_password.dart';
import 'edit_profile_layout.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = sharedPreferences!.getString("name")!;
    phoneController.text = sharedPreferences!.getString("phone")!;
    emailController.text = sharedPreferences!.getString("email")!;
    locationController.text = address;
    zoneController.text = zone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipOval(
                        child: Image.network(sharedPreferences!.getString("photoUrl")!,
                          fit: BoxFit.cover,
                        )
                    )
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    obscureText: false,
                    enabled: false,
                    controller: nameController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Colors.black
                        ),
                        labelText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          obscureText: false,
                          enabled: false,
                          controller: phoneController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                  color: Colors.black
                              ),
                              labelText: "Phone Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      ),
                      Positioned(
                          bottom:  26,
                          right: 18,
                          child: Container(
                            height: 17,
                            width: 17,
                            decoration: const BoxDecoration(
                            ),
                            child: Icon(Icons.verified,
                                color: Colors.blueAccent.shade400),
                          )
                      )
                    ]
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.black
                        ),
                        obscureText: false,
                        enabled: false,
                        controller: emailController,
                        decoration: InputDecoration(
                            labelStyle: const TextStyle(
                                color: Colors.black
                            ),
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                      ),
                    ),
                    Positioned(
                        bottom:  26,
                        right: 18,
                        child: Container(
                          height: 17,
                          width: 17,
                          decoration: const BoxDecoration(
                          ),
                          child: Icon(Icons.verified,
                              color: Colors.blueAccent.shade400),
                        )
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    obscureText: false,
                    enabled: false,
                    controller: locationController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Colors.black
                        ),
                        labelText: "Location",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: TextFormField(
                    style: const TextStyle(
                        color: Colors.black
                    ),
                    obscureText: false,
                    enabled: false,
                    controller: zoneController,
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(
                            color: Colors.black
                        ),
                        labelText: "Zone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return ChangePassword();
                    },
                    ),
                    );
                  },
                  child: const Text("Change Password",
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => EditProfile()));
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
                    child: Text("Edit Profile",
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
    );
  }
}
