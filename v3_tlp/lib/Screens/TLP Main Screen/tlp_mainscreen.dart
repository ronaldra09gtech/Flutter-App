import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3_tlp/Screens/Request%20Load/request_load.dart';
import 'package:v3_tlp/Screens/Transfer%20Load/queuers_load_transfer.dart';
import 'package:v3_tlp/global/global.dart';
import 'package:intl/intl.dart';
import '../../Splash Screen/login.dart';


class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool?> showWarning(BuildContext context) async =>  showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to Log out?"),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen() ));
              },
              child: const Text("Yes")
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No")
          ),
        ],
      )
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text("The Pilamoko Top-up Load Providing System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueAccent.shade400
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF262AAA),
                  ),
                  height: 120,
                  width: 250,
                   child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       const SizedBox(height: 10),
                        const Text(
                        "Balance",
                        style: TextStyle(
                           color: Colors.white,
                             fontSize: 24
                          ),
                        ),
                      const SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("pilamokotlp")
                            .where("pilamokotlpUID", isEqualTo: sharedPreferences!.getString("uid"))
                            .snapshots(),
                        builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }
                          return Column(
                            children: snapshot.data!.docs.map((document){
                              return Text(
                                "₱ ${document['loadWallet']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                       ],
                     ),
                   ),
                const SizedBox(height: 40,),
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const QueuerTransferLoad() ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.shade400
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text("Transfer Load",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const RequestLoad() ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.shade400
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text("Request Load",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40,),
                Divider(
                  thickness: 2,
                  color: Colors.blueAccent.shade400
                ),
                const SizedBox(height: 15,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transfer Load History",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.blueAccent.shade400
                      ),
                    ),
                    Text("See All",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Colors.blueAccent.shade400
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("tlpLoadTransactions")
                      .where("tlpUID", isEqualTo: sharedPreferences!.getString("uid"))
                      .orderBy("loadTransferTime", descending: true)
                      .limit(4)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    return snapshot.hasData
                        ? Column(
                      children: snapshot.data!.docs.map((document){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(document['queueremail']),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.30),
                                      Text(document['userType']),

                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(DateFormat("dd MMMM, yyyy")
                                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document['loadTransferTime'])))),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.30),
                                      // ignore: prefer_interpolation_to_compose_strings
                                      Text("₱"+document['amount']),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
