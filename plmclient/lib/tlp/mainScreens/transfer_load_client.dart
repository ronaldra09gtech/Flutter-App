import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plmclient/tlp/mainScreens/transfer_load_screen.dart';

import '../../main.dart';
import '../global/global.dart';
import '../widgets/error_dialog.dart';

class TransferLoadClient extends StatefulWidget {
  const TransferLoadClient({Key? key}) : super(key: key);

  @override
  _TransferLoadClientState createState() => _TransferLoadClientState();
}

class _TransferLoadClientState extends State<TransferLoadClient> {

  String transactionID = DateTime.now().millisecondsSinceEpoch.toString();
  String clientName = "";
  String previousLoad = "";
  Future<void> formValidation() async {
    if (amount.text.isNotEmpty && account.text.isNotEmpty) {
      if(double.parse(loadWallet).toDouble() > double.parse(amount.text).toDouble()){
        createRequest();
      }
      else{
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Insufficient Load.",
              );
            }
        );
      }
    }
    else {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please Fill all Fields.",
            );
          }
      );
    }
  }

  Future createRequest() async {
    FirebaseFirestore.instance
        .collection("pilamokoclient")
        .doc(account.text)
        .get()
        .then((snap){
      if(snap.exists){
        setState(() {
          clientName = snap.data()!['name'].toString();
          previousLoad = snap.data()!['loadWallet'].toString();
          zone = snap.data()!['zone'].toString();

        });
        String totalAmount = ( (double.parse(previousLoad)) + (double.parse(amount.text)) ).toString();
        FirebaseFirestore.instance
            .collection("pilamokoclient")
            .doc(account.text)
            .update({
          "loadWallet": totalAmount,
        }).then((value){
          String newLoadWalletValue = ((double.parse(loadWallet)) - (double.parse(amount.text))).toString();
          FirebaseFirestore.instance
              .collection("pilamokotlp")
              .doc(sharedPreferences!.getString("uid")!)
              .update({
            "loadWallet": newLoadWalletValue,
          });
        }).then((value){
          FirebaseFirestore.instance
              .collection("tlpLoadTransactions")
              .doc(transactionID)
              .set({
            "amount": amount.text.trim(),
            "name": account.text,
            "loadTransferTime": transactionID,
            "userType": "client",
            "zone": zone,
            "isSuccess": true,
            "tlpUID": sharedPreferences!.getString("uid"),
            "transactionUID": transactionID,
          });
        });
        Navigator.push(context, MaterialPageRoute(builder: (c)=> TransferLoadScreen()));
        Fluttertoast.showToast(msg: "Load Transfer Successfully.");
      }
      else {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const TransferLoadScreen()));
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "No record found.",
              );
            }
        );
      }
    });

  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amount = TextEditingController();
  TextEditingController account = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.lightBlue,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  enabled: true,
                  controller: account,
                  obscureText: false,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    hintText: "Enter Email or Phone number",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  enabled: true,
                  controller: amount,
                  obscureText: false,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.monetization_on_outlined,
                      color: Colors.blue,
                    ),
                    focusColor: Theme.of(context).primaryColor,
                    hintText: "Enter Amount",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FloatingActionButton.extended(
                label: const Text("Submit", style: TextStyle(fontSize: 16)),
                backgroundColor: Colors.blueAccent,
                onPressed: ()
                {
                  formValidation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

