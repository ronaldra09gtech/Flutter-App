import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/pic_queuer.dart';
import 'package:plmclient/client/widgets/simple_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../global/global.dart';

class MyQueuer extends StatefulWidget {
  const MyQueuer({Key? key}) : super(key: key);

  @override
  State<MyQueuer> createState() => _MyQueuerState();
}

class _MyQueuerState extends State<MyQueuer> {

  String name="";
  String email="";
  String photo="";
  String contact="";
  String zone="";

  getQueuerInfo()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(queuer)
        .get()
        .then((snap){
      setState(() {
        name = snap.data()!['pilamokoqueuerEmail'].toString();
        email = snap.data()!['pilamokoqueuerName'].toString();
        photo = snap.data()!['pilamokoqueuerAvatarUrl'].toString();
        contact = snap.data()!['phone'].toString();
        zone = snap.data()!['zone'].toString();
      });
    });
  }

  deleteQueuer()
  {
    FirebaseFirestore.instance
        .collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email"))
        .update({
      "queuer":"",
    }).then((value){
      FirebaseFirestore.instance
          .collection("queuerClientList")
          .doc(queuer)
          .collection("Clients")
          .doc(sharedPreferences!.getString("email").toString()).delete();
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> PickQueuer()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQueuerInfo();
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
                "Change Queuer",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                deleteQueuer();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              child: const Text(
                "Call my Queuer",
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
