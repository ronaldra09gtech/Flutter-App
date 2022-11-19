import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Transfer%20Load/transfer_load.dart';

import '../../global/global.dart';

class MyQueuersLayOut extends StatefulWidget {
  const MyQueuersLayOut({Key? key}) : super(key: key);

  @override
  State<MyQueuersLayOut> createState() => _MyQueuersLayOutState();
}

class _MyQueuersLayOutState extends State<MyQueuersLayOut> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("pilamokoqueuer")
                .where("tlp", isEqualTo: sharedPreferences!.getString("uid"))
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 12),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.blue,
                  ),
                ),
              )
                  : ListView(
                children: snapshot.data!.docs.map((document){
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 70,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("List of my Queuers",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.blueAccent.shade400
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.black
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (c) => TranferLoad(queueremail: document['pilamokoqueuerEmail'],)));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(document['pilamokoqueuerName'])),
                                    const SizedBox(width: 40),
                                    // ignore: prefer_interpolation_to_compose_strings
                                    Expanded(child: Text("₱ "+document['loadWallet'].toString())),
                                  ],
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
