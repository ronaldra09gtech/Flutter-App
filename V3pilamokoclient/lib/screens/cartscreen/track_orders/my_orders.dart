import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../assistantMethods/assistant_methods.dart';
import '../../../global/global.dart';
import '../../../widgets/order_cart.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("orderBy", isEqualTo: sharedPreferences!.getString("email"))
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
                      ? snap.data!.size > 0
                      ? OrderCart(
                    itemCount: snap.data!.docs.length,
                    data: snap.data!.docs,
                    orderID: snapshot.data!.docs[index].id,
                    seperateQuantitiesList: separateOrderItemQuantities((snapshot.data!.docs[index].data()! as Map<String, dynamic>)["productIDs"]),
                  )
                      : Center(child: Text("No Data"),)
                      : Center(child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 12),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.blue,
                      ),
                    ),
                  ),);
                },
              );
            },
          )
              : Center(child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 12),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.blue,
              ),
            ),
          ),);
        },
      ),
    );
  }
}
