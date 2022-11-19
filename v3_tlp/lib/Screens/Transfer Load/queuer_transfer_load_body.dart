import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:v3_tlp/widgets/error_dialog.dart';
import '../../global/global.dart';
import '../../widgets/loading_dialog.dart';
import '../Profile/edit_profile_side_layout.dart';
import '../TLP Main Screen/sidelayouthome.dart';

class QueuerTransferLoadBody extends StatefulWidget {
  const QueuerTransferLoadBody({Key? key}) : super(key: key);

  @override
  State<QueuerTransferLoadBody> createState() => _QueuerTransferLoadBodyState();
}

class _QueuerTransferLoadBodyState extends State<QueuerTransferLoadBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController account = TextEditingController();

  bool tlpname = false;
  String? loadwalletbalance;
  String? queuerloadwalletbalance;
  String transactionID = DateTime.now().millisecondsSinceEpoch.toString();

  sendLoad()async{
    if(!tlpname){
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c)
          {
            return AlertDialog(
              content: const Text("Please complete your profile details to send load"),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: ()
                  {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> const SideBarLayoutEditProfile()));
                  },
                  child: const Center(
                    child: Text("OK"),
                  ),
                ),
              ],
            );
          }
      );
    }
    else{
      String totalAmount = ((double.parse(queuerloadwalletbalance!)) + (double.parse(amount.text)) ).toString();
      await FirebaseFirestore.instance
          .collection("pilamokoqueuer")
          .doc(account.text)
          .update({
        "loadWallet": double.parse(totalAmount),
      }).then((value) async {
        String newLoadWalletValue = ((double.parse(loadwalletbalance!)) - (double.parse(amount.text))).toString();
        await FirebaseFirestore.instance
            .collection("pilamokotlp")
            .doc(sharedPreferences!.getString("uid")!)
            .update({
          "loadWallet": double.parse(newLoadWalletValue),
        }).whenComplete(() async {
          String currentDateTime = DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(transactionID)));
          await FirebaseFirestore.instance
              .collection("tlpLoadTransactions")
              .doc(transactionID)
              .set({
            "amount": amount.text.trim(),
            "queueremail": account.text,
            "userType": "queuer",
            "loadTransferTime": transactionID,
            "date": currentDateTime,
            "zone": zone,
            "isSuccess": true,
            "tlpUID": sharedPreferences!.getString("uid"),
            "transactionUID": transactionID,
          });
        }).whenComplete((){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const SideBarLayoutHome()));
          Fluttertoast.showToast(msg: "Load Transfer Successfully.");
        });
      });
    }
  }

  getQueuerData() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c)
        {
          return const LoadingDialog(
            message: "Processing",
          );
        }
    );
    await FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(account.text)
        .get()
        .then((snap){
          if(snap.exists){
            setState(() {
              queuerloadwalletbalance = snap.data()!['loadWallet'].toString();
            });
            sendLoad();
          }
          else {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (c)
                {
                  return const ErrorDialog(
                    message: "No Queuer Found. Check Queuer email address",
                  );
                }
            );
          }
    });


  }

  getTlpData()async
  {
    await FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap){
          if(snap.data()!['pilamokotlpName'].toString() != ""){
            setState(() {
              loadwalletbalance = snap.data()!['loadWallet'].toString();
              tlpname = true;
            });
          }
          else {
            setState(() {
              loadwalletbalance = snap.data()!['loadWallet'].toString();
            });
          }

    });
  }

  @override
  void initState() {
    super.initState();
    getTlpData();
  }


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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Transfer Load",
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
                        const SizedBox(height: 10),
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
                      TextFormField(
                        controller: account,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                            labelText: "Queuer Email Address",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter queuer email address";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: amount,
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
                        validator: (value){
                          if(value!.isEmpty){
                            return "Input Amount";
                          }
                          if(double.parse(value) < 200){
                            return "Minimum of 200";
                          }
                          if(double.parse(value) > double.parse(loadwalletbalance.toString())){
                            return "You don't have enough load";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: (){
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            // formValidation();
                            // sendLoad();
                            getQueuerData();
                          }
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
                          child: Text("Transfer",
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
                      const SizedBox(
                        height: 20,
                      ),
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
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.40),
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
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.38),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
