import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/authentication/pick_tlp_screen.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/home_screen.dart';
import 'package:plmclient/queuer/widgets/simple_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class MyTLPScreen extends StatefulWidget {
  const MyTLPScreen({Key? key}) : super(key: key);

  @override
  State<MyTLPScreen> createState() => _MyTLPScreenState();
}

class _MyTLPScreenState extends State<MyTLPScreen> {

  String name="";
  String email="";
  String photo="";
  String contact="";
  String zone="";

  getTLPInfo()
  {
    FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(tlp)
        .get()
        .then((snap){
      setState(() {
        name = snap.data()!['pilamokotlpEmail'].toString();
        email = snap.data()!['pilamokotlpName'].toString();
        photo = snap.data()!['pilamokotlpAvatarUrl'].toString();
        contact = snap.data()!['phone'].toString();
        zone = snap.data()!['zone'].toString();
      });
    });
  }

  deleteTLP()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email"))
        .update({
      "tlp":"",
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> PickTLPScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTLPInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Profile",
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 250,
            width: 250,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(photo),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FlatButton(
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.grey[200],
              onPressed: (){},
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.person),
                  ),
                  Expanded(child: Text(name, style: const TextStyle(fontSize: 15,fontFamily: "Verela"),))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FlatButton(
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.grey[200],
              onPressed: (){},
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.mail),
                  ),
                  Expanded(child: Text(email,style: const TextStyle(fontSize: 15,fontFamily: "Verela"),))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FlatButton(
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.grey[200],
              onPressed: (){},
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.phone),
                  ),
                  Expanded(child: Text(contact, style: const TextStyle(fontSize: 15,fontFamily: "Verela")))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: FlatButton(
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              color: Colors.grey[200],
              onPressed: (){},
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.location_on),
                  ),
                  Expanded(child: Text(zone, style: const TextStyle(fontSize: 15,fontFamily: "Verela")))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              child: const Text(
                "Change TLP",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                deleteTLP();
                // Navigator.push(context, MaterialPageRoute(builder: (c)=> EditProfile()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              child: const Text(
                "Call my TLP",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                launch('tel://${contact}');
                // Navigator.push(context, MaterialPageRoute(builder: (c)=> EditProfile()));
              },
            ),
          )
        ],
      ),
    );
  }
}
