import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:v3_tlp/Screens/Profile/edit_profile_side_layout.dart';

import '../../global/global.dart';
import '../../widgets/loading_dialog.dart';
import '../TLP Main Screen/sidelayouthome.dart';


class TransferLoadBody extends StatefulWidget {
  String? queueremail;

  TransferLoadBody({super.key, this.queueremail});

  @override
  State<TransferLoadBody> createState() => _TransferLoadBodyState();
}

class _TransferLoadBodyState extends State<TransferLoadBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();

  bool tlpname = false;
  String? loadwalletbalance;
  String? queuerloadwalletbalance;
  String transactionID = DateTime.now().millisecondsSinceEpoch.toString();

  sendLoad()async{
    if(tlpname!= ""){
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
      String totalAmount = ((double.parse(queuerloadwalletbalance!)) + (double.parse(amount.text)) ).toString();
      await FirebaseFirestore.instance
          .collection("pilamokoqueuer")
          .doc(widget.queueremail)
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
            "queueremail": widget.queueremail,
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
    await FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(widget.queueremail)
        .get()
        .then((snap){
      setState(() {
        queuerloadwalletbalance = snap.data()!['loadWallet'].toString();
      });
    });
  }

  getTlpData()async
  {
    await FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap){
      setState(() {
        if(snap.data()!['pilamokotlpName'].toString() != ""){
          setState(() {
            loadwalletbalance = snap.data()!['loadWallet'].toString();
            tlpname = true;
          });
        }
        else{
          setState(() {
            loadwalletbalance = snap.data()!['loadWallet'].toString();
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTlpData();
    getQueuerData();
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
                          Map<String, dynamic> data = snapshot.data!.docs.single.data() as Map<String, dynamic>;
                          return snapshot.hasData
                              ? Column(
                            children: [
                              Text(
                                "₱ ${data['loadWallet']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                              : const Text(
                            "Loading..." ,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                            sendLoad();
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
                          child: Text("Send",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent.shade400,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
