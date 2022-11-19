import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/emall/emall_menus_screen.dart';
import 'package:plmclient/client/models/emall/emall.dart';
import 'package:plmclient/client/widgets/my_drawer.dart';

import '../../../main.dart';

class EMallScreen extends StatefulWidget {
  const EMallScreen({Key? key}) : super(key: key);

  @override
  _EMallScreenState createState() => _EMallScreenState();
}

class _EMallScreenState extends State<EMallScreen>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearCartNow(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlueAccent,
                  Colors.blue,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          sharedPreferences!.getString("name")!,
          style: const TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot> (
        stream: FirebaseFirestore.instance
            .collection("pilamokoemall")
            .where("zone", isEqualTo: zone)
            .snapshots(),
        builder: (c, snapshot)
        {
          return snapshot.hasData
              ? ListView(
            children: snapshot.data!.docs.map((document){
              return InkWell(
                  onTap: ()
                  {
                    Emalldata? emalldata = Emalldata();
                    emalldata.pilamokosellerAvatarUrl = document['pilamokoemallAvatarUrl'];
                    emalldata.pilamokosellerEmail = document['pilamokoemallEmail'];
                    emalldata.pilamokosellerName = document['pilamokoemallName'];
                    emalldata.pilamokosellerUID = document['pilamokoemallUID'];
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> EmallMenusScreen(model: emalldata)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: 285,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Divider(
                            height: 4,
                            thickness: 3,
                            color: Colors.grey[300],
                          ),
                          Image.network(
                            document['pilamokoemallAvatarUrl'],
                            height: 210.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 2.0,),
                          Text(
                            document['pilamokoemallName'],
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 20,
                              fontFamily: "Train",
                            ),
                          ),

                          Text(
                            document['pilamokoemallEmail'],
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 12,
                            ),
                          ),
                          Divider(
                            height: 4,
                            thickness: 3,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                  )
              );
            }).toList(),
          )
              : const Center(child: Text("No Items Yet yet"),);
        },
      ),
    );
  }
}
