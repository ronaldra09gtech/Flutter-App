import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/merchat/mall/widgets/order_card.dart';

import '../../../../client/assistantMethods/assistant_methods.dart';
import '../../../../client/widgets/progress_bar.dart';
import '../../../../main.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({Key? key}) : super(key: key);

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
          .where("status", whereIn: ["done"])
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
