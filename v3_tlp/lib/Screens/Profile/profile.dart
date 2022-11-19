import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Profile/change_password.dart';
import 'package:v3_tlp/Screens/Profile/edit_profile_side_layout.dart';
import 'package:v3_tlp/global/global.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      emailController.text = sharedPreferences!.getString("email")!;
      phoneController.text = sharedPreferences!.getString("phone")!;
      nameController.text = sharedPreferences!.getString("name")!;
    });
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                    height: 200,
                    width: 200,
                    child: ClipOval(
                      child: sharedPreferences!.getString("photoUrl")! == ""
                          ? Image.network("https://t3.ftcdn.net/jpg/03/46/83/96/240_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
                        fit: BoxFit.cover,
                      )
                          : Image.network(sharedPreferences!.getString("photoUrl")!,
                        fit: BoxFit.cover,
                      )
                    )
                ),
                const SizedBox(height: 50),
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
                SizedBox(height: 20,),
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
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const SideBarLayoutEditProfile()));
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
