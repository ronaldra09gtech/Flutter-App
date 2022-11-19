import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../global/global.dart';
import '../widgets/progress_bar.dart';

class TransferHistory extends StatefulWidget {
  const TransferHistory({Key? key}) : super(key: key);

  @override
  _TransferHistoryState createState() => _TransferHistoryState();
}

class _TransferHistoryState extends State<TransferHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("tlpLoadTransactions")
            .where("tlpUID", isEqualTo: sharedPreferences!.getString("uid"))
            .orderBy("loadTransferTime", descending: true)
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
                        Text("TransactionID: "+ document['transactionUID']),
                        const SizedBox(height: 15,),
                        Text("Email: "+ document['name']),
                        const SizedBox(height: 15,),
                        Text("Amount: "+ document['amount']),
                        const SizedBox(height: 15,),
                        Text("Date: "+DateFormat("dd MMMM, yyyy - hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['loadTransferTime'])))),
                        const SizedBox(height: 15,),
                        Text("User Type: "+ document['userType']),
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
