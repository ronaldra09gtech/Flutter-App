import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../global/global.dart';
import '../widgets/simple_app_bar.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  getTlpData()
  {
    FirebaseFirestore.instance
        .collection("pilamokoseller")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap){
      setState(() {
        email = snap.data()!['pilamokosellerEmail'].toString();
        phone = snap.data()!['phone'].toString();
        zone = snap.data()!['zone'].toString();
        number = snap.data()!['earning'].toString();
        loadWallet = snap.data()!['loadWallet'].toString();
      });
    });
  }

  @override
  void initState() {
    getTlpData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Profile",
      ),
      body: Column(
        children: [
          SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                  backgroundImage:
                  NetworkImage(sharedPreferences!.getString("photoUrl")!),
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
                  Expanded(child: Text(sharedPreferences!.getString('name')!, style: const TextStyle(fontSize: 15,fontFamily: "Verela"),))
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
                  Expanded(child: Text(phone, style: const TextStyle(fontSize: 15,fontFamily: "Verela")))
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
                  Expanded(child: Text(address, style: const TextStyle(fontSize: 15,fontFamily: "Verela")))
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
          ElevatedButton(
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EditProfile()));
            },
          )
        ],
      ),
    );
  }
}



