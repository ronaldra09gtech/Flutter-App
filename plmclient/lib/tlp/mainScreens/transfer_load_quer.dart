import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/tlp/mainScreens/transfer_load_queuer.dart';

import '../../main.dart';
import '../global/global.dart';
import '../widgets/progress_bar.dart';

class TransLoadQueuer extends StatefulWidget {
  const TransLoadQueuer({Key? key}) : super(key: key);

  @override
  State<TransLoadQueuer> createState() => _TransLoadQueuerState();
}

class _TransLoadQueuerState extends State<TransLoadQueuer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("pilamokoqueuer")
            .where("tlp", isEqualTo: sharedPreferences!.getString("uid"))
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
        {
          if(!snapshot.hasData)
          {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data!.docs.map((document){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> TransferLoadQueuer(queuer: document['pilamokoqueuerEmail'],)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: "+ document['pilamokoqueuerName'],style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 15,),
                          Text("Email: "+ document['pilamokoqueuerEmail'],style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 15,),
                          Text("Phone: "+ document['phone'],style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 15,),
                          Text("Load Wallet: ₱"+ document['loadWallet'].toString(),style: TextStyle(fontSize: 16),),
                          const SizedBox(height: 15,),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
