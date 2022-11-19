import 'package:flutter/material.dart';
import 'package:plmclient/client/authentication/authScreen.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/home_screen.dart';
import 'package:plmclient/client/mainScreens/my_orders_screen.dart';
import 'package:plmclient/client/mainScreens/pakidala/paki_dala_screen.dart';
import 'package:plmclient/client/mainScreens/pic_queuer.dart';
import 'package:plmclient/client/mainScreens/profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../mainScreens/my_booking_screen.dart';
import '../mainScreens/my_queuer_screen.dart';

class MyDrawer extends StatelessWidget
{

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
                        backgroundImage: sharedPreferences!.getString("photoUrl") != ""
                            ? NetworkImage(sharedPreferences!.getString("photoUrl")!)
                            : NetworkImage("https://portal.staralliance.com/imagelibrary/aux-pictures/prototype-images/avatar-default.png/@@images/image.png")
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
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle, color: Colors.black),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const ProfileScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.person_sharp, color: Colors.black),
                  title: const Text(
                    "My Trusted Queuer",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    if(queuer!.isNotEmpty)
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> MyQueuer()));
                    }
                    else
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> PickQueuer()));
                    }
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black),
                  title: const Text(
                    "Track My Orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MyOrdersScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black),
                  title: const Text(
                    "Track My Queuing Services",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MyBookingScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.black),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: ()
                  {

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
                  onTap: () async
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
