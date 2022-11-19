import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/assistantMethods/assistant_methods.dart';
import 'package:plmclient/queuer/global/global.dart';
import 'package:plmclient/queuer/widgets/order_card.dart';
import 'package:plmclient/queuer/widgets/progress_bar.dart';
import 'package:plmclient/queuer/widgets/simple_app_bar.dart';



class EmallNewOrdersScreen extends StatefulWidget
{
  @override
  _EmallNewOrdersScreenState createState() => _EmallNewOrdersScreenState();
}

class _EmallNewOrdersScreenState extends State<EmallNewOrdersScreen>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "New Orders",),
        body: StreamBuilder<QuerySnapshot> (
          stream: FirebaseFirestore.instance
              .collection("orders")
              .where("status", isEqualTo: "ready")
              .where("serviceType", isEqualTo: "emall")
              .where("zone", isEqualTo: zone)
              .orderBy("orderTime", descending: true)
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index)
              {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID", whereIn: separateOrderItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                      .where("orderBy", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                      .orderBy("publishDate", descending: true)
                      .get(),
                  builder: (c, snap)
                  {
                    return snap.hasData
                        ? OrderCard(
                      itemCount: snap.data!.docs.length,
                      data: snap.data!.docs,
                      orderID: snapshot.data!.docs[index].id,
                      seperateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                    )
                        : Center(child: circularProgress());
                  },
                );
              },
            )
                : const Center(child: Text("No Orders yet"),);
          },
        ),
      ),
    );
  }
}
