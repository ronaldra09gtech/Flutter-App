import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/client/assistantMethods/address_changer.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/save_address_screen.dart';
import 'package:plmclient/client/models/address.dart';
import 'package:plmclient/client/splashScreen/splashScreen.dart';
import 'package:plmclient/client/widgets/address_design.dart';
import 'package:plmclient/client/widgets/progress_bar.dart';
import 'package:plmclient/client/widgets/simple_app_bar.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class AddressScreen extends StatefulWidget {

  final double? totalAmount;
  final String? pilamokosellerUID;

  AddressScreen({this.totalAmount, this.pilamokosellerUID});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Pilamoko",),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (c)=> SaveAddressScrenn()));

        },
        label: const Text("Add New Address"),
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add_location),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child:  Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Select Address: ",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          Consumer<AddressChanger>(builder: (context, address, c){
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("pilamokoclient")
                    .doc(sharedPreferences!.getString("email"))
                    .collection("userAddress")
                    .snapshots(),
                builder: (context, snapshot)
                {
                  return !snapshot.hasData
                      ? Center(child: circularProgress(),)
                      : snapshot.data!.docs.isEmpty
                      ? Container()
                      : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index)
                    {
                      return AddressDesign(
                        currentIndex: address.count,
                        value: index,
                        addressID: snapshot.data!.docs[index].id,
                        totalAmount: widget.totalAmount,
                        sellerUID: widget.pilamokosellerUID,
                        model: Address.fromJson(
                            snapshot.data!.docs[index].data()! as Map<String, dynamic>
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
