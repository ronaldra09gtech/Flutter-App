import 'package:flutter/material.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/widgets/simple_app_bar.dart';

import '../../main.dart';
import 'edit_profile.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Profile",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: 250 ,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundImage: sharedPreferences!.getString("photoUrl") != ""
                        ? NetworkImage(sharedPreferences!.getString("photoUrl")!)
                        : NetworkImage("https://portal.staralliance.com/imagelibrary/aux-pictures/prototype-images/avatar-default.png/@@images/image.png")

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
                      child: Icon(Icons.monetization_on_outlined),
                    ),
                    Expanded(child: Text("Load Wallet: ₱ "+loadWallet, style: const TextStyle(fontSize: 15,fontFamily: "Verela"),))
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
                    Expanded(child: Text(sharedPreferences!.getString('email')!,style: const TextStyle(fontSize: 15,fontFamily: "Verela"),))
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
                    Expanded(child: Text(phone,style: const TextStyle(fontSize: 15,fontFamily: "Verela"),))
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
      ),
    );
  }
}



