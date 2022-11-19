import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/merchat/mall/assistantMethods/assistant_methods.dart';
import 'package:plmclient/merchat/mall/widgets/order_card.dart';
import 'package:plmclient/merchat/mall/widgets/progress_bar.dart';
import 'package:plmclient/merchat/mall/widgets/simple_app_bar.dart';

import '../../../../main.dart';

class NewOrdersScreen extends StatefulWidget
{
  @override
  _NewOrdersScreenState createState() => _NewOrdersScreenState();
}

class _NewOrdersScreenState extends State<NewOrdersScreen>
{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
          .where("status", isEqualTo: "normal")
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
                  .where("sellerUID", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
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
            : Center(child: circularProgress(),);
      },
    );
  }
}
