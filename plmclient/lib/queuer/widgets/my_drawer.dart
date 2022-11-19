import 'package:flutter/material.dart';
import 'package:plmclient/queuer/authentication/pick_tlp_screen.dart';
import 'package:plmclient/queuer/mainScreens/history/history_dashboard.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/walker_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/my_tlp.dart';
import 'package:plmclient/queuer/mainScreens/validation/has_validation.dart';
import 'package:plmclient/queuer/mainScreens/validation/walker_validation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../authentication/authScreen.dart';
import '../global/global.dart';
import '../mainScreens/homescreen/bike_homescreen.dart';
import '../mainScreens/homescreen/home_screen.dart';
import '../mainScreens/profile_screen/profile_screen.dart';

class MyDrawer extends StatefulWidget
{
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //drawer header
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child:  Column(
              children:  [
                //header drawer
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(sharedPreferences!.getString("name")!,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Train"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12,),
          //drawer body
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.black),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    if(sharedPreferences!.getString("queuerType")!.toString() == "Walking Queuer"){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerHomeScreen()));
                    }
                    else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Bike / Bike"){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> BikerHomeScreen()));
                    }
                    else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Motorcycle" || sharedPreferences!.getString("queuerType")!.toString() == "Queuer with 4 Wheels"){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                    }
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> ProfileScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner_outlined, color: Colors.black),
                  title: const Text(
                    "Validation",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                      if(sharedPreferences!.getString("queuerType")!.toString() == "Walking Queuer"){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerValidation()));
                      }
                      else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Bike / Bike"){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> HasValidation()));
                      }
                      else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Motorcycle" || sharedPreferences!.getString("queuerType")!.toString() == "Queuer with 4 Wheels"){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> HasValidation()));
                      }
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner_outlined, color: Colors.black),
                  title: const Text(
                    "My TLP",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    if(tlp! != "" && tlp!.isNotEmpty)
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> MyTLPScreen()));
                    }
                    else
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> PickTLPScreen()));
                    }
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner_outlined, color: Colors.black),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryDashboard()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.black),
                  title: const Text(
                    "Support",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    final url = 'https://kt-portal.com/';
                      launch(url);
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.black),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    firebaseAuth.signOut().then((value){
                      setState(() {
                        tlp = "";
                        pilamokoqueuerLicenseUrl = "";
                        pilamokoqueuerOrcrUrl = "";
                        pilamokoqueuerBillingUrl = "";
                        validID = "";
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
