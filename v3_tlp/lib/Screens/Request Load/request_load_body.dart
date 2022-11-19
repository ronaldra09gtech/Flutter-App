import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../global/global.dart';


class RequestLoadBody extends StatefulWidget {
  const RequestLoadBody({Key? key}) : super(key: key);

  @override
  State<RequestLoadBody> createState() => _RequestLoadBodyState();
}

class _RequestLoadBodyState extends State<RequestLoadBody> {
  late final WillPopCallback? onWillPop;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      return true;
    },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 70,
              left: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Request Load",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueAccent.shade400
                  ),
                ),
                const SizedBox(height: 40),
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
                      const Text("Current Balance",
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
                const SizedBox(height: 40),
                Column(
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                          labelText: "Amount",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
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
                        child: Text("Request",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Divider(
                      thickness: 2,
                      color: Colors.blueAccent.shade400,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Request History",
                      style: TextStyle(
                        color: Colors.blueAccent.shade400,
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("tlpLoadRequest")
                          .where("tlpUID", isEqualTo: sharedPreferences!.getString("uid"))
                          .orderBy("loadTransferTime", descending: true)
                          .limit(4)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.size > 0){
                            return Column(
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
                            );
                          }
                          else {
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
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("You have no request.")
                                ),
                              ),
                            );
                          }
                        }
                        else {
                          return Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text("There's no load Request")
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
