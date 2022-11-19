import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../widgets/simple_app_bar.dart';
import '../global/global.dart';
import '../widgets/progress_bar.dart';

class ListQueuer extends StatefulWidget {
  const ListQueuer({Key? key}) : super(key: key);

  @override
  State<ListQueuer> createState() => _ListQueuerState();
}

class _ListQueuerState extends State<ListQueuer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "List of Queuer",),
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
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
