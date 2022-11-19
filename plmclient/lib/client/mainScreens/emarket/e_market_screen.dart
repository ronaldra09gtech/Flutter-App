import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/emarket/emarket_menus_screen.dart';
import 'package:plmclient/client/models/emarket/emarket.dart';
import 'package:plmclient/client/widgets/my_drawer.dart';

import '../../../main.dart';


class EMarketScreen extends StatefulWidget {
  const EMarketScreen({Key? key}) : super(key: key);

  @override
  _EMarketScreenState createState() => _EMarketScreenState();
}

class _EMarketScreenState extends State<EMarketScreen>
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
            .collection("pilamokoemarket")
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
                    Emarket services = Emarket();
                    services.pilamokosellerAvatarUrl = document['pilamokoemarketAvatarUrl'];
                    services.pilamokosellerEmail = document['pilamokoemarketEmail'];
                    services.pilamokosellerName = document['pilamokoemarketName'];
                    services.pilamokosellerUID = document['pilamokoemarketUID'];
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> EMarketMenusScreen(model: services)));

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
                            document['pilamokoemarketAvatarUrl'],
                            height: 210.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 2.0,),
                          Text(
                            document['pilamokoemarketName'],
                            style: const TextStyle(
                              color: Colors.cyan,
                              fontSize: 20,
                              fontFamily: "Acme",
                            ),
                          ),

                          Text(
                            document['pilamokoemarketEmail'],
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
