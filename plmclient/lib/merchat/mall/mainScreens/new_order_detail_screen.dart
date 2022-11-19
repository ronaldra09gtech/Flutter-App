import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/merchat/mall/mainScreens/home_Screen.dart';

import '../../../client/assistantMethods/assistant_methods.dart';
import '../../../client/widgets/order_cart.dart';
import '../../../client/widgets/progress_bar.dart';
import 'package:intl/intl.dart';


class OrderDetailsSrceen2 extends StatefulWidget {
  final String? orderID;

  OrderDetailsSrceen2({this.orderID});

  @override
  State<OrderDetailsSrceen2> createState() => _OrderDetailsSrceen2State();
}

class _OrderDetailsSrceen2State extends State<OrderDetailsSrceen2> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerID = "";
  String userID = "";
  String paymentDetails = "";
  int count=0;
  List <String>? seperateQuantitiesList ;
  bool isVisible = true;
  bool isVisible2 = false;

  getOrderInfo() async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) async
    {
      setState(() {
        orderStatus = DocumentSnapshot.data()!["status"].toString();
        orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
        sellerID = DocumentSnapshot.data()!["sellerUID"].toString();
        count = DocumentSnapshot.data()!.length;
        paymentDetails = DocumentSnapshot.data()!["paymentDetails"].toString();
      });
      if(orderStatus == "accepted" || orderStatus == "ready" || orderStatus == "picking" || orderStatus == "delivering"){
        setState(() {

          isVisible = false;
        });
      }

    });
  }

  @override
  void initState() {

    getOrderInfo();
  }

  acceptOrder(String orderID)
  {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderID)
        .update({
      "status": "accepted",
    });
  }

  orderisReady(String orderID){
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderID)
        .update({
      "status": "ready",
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreenEmall()));
  }
  declineOrder(String orderID){
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderID)
        .update({
      "status": "declined",
    });
  }

    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white70.withOpacity(.9),
        appBar: AppBar(
          backgroundColor: Colors.white,
        title: Text("Order Details"),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.blue,
          )
        ),
        body: ListView(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("orders")
                  .doc(widget.orderID)
                  .get(),
              builder: (c, snapshot)
              {
                Map? dataMap;
                if(snapshot.hasData)
                {
                  dataMap = snapshot.data!.data()! as Map<String, dynamic>;
                  orderStatus = dataMap["status"].toString();
                }
                return snapshot.hasData
                    ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("pilamokoclient")
                            .doc(orderByUser)
                            .collection("userAddress")
                            .doc(dataMap!["addressID"])
                            .get(),
                        builder: (c, snapshot)
                        {
                          return snapshot.hasData
                              ? Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.white,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                            Icon(Icons.location_on_outlined),
                                            Text(
                                              "Delivery Address",
                                              style: TextStyle(
                                                  fontSize: 22
                                              ),
                                            ),
                                      ],
                                    ),
                                    Text(
                                        snapshot.data!["name"]!.toString(),
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    Text(
                                        snapshot.data!["phoneNumber"]!.toString(),
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!["fullAddress"]!.toString(),
                                      style: TextStyle(
                                          fontSize: 16
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : Center(child: circularProgress(),);
                        },
                      ),
                    ],
                  ),
                )
                    : Center(child: circularProgress(),);
              },
            ),
            SizedBox(height: 5,),
            Container(
              height: 220,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("orders")
                    .where("orderId", isEqualTo: widget.orderID)
                    .orderBy("orderTime", descending: true)
                    .snapshots(),
                builder: (c, snapshot)
                {
                  return snapshot.hasData
                      ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                              ? OrderCart(
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
              ),
            ),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Payment Method",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(paymentDetails)
                ],
              ),
            ),
            SizedBox(height: 5,),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Order ID",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                          widget.orderID!,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order Time"),
                      Text(DateFormat("dd-MM-yyyy hh:mm aa")
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.orderID!))),)
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
            orderStatus == "done"
                ? Container()
                : Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8, top: 5, bottom: 2),
                    child: orderStatus == "ready" || orderStatus == "picking" || orderStatus == "delivering"
                        ? Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(40),
                              ),
                              onPressed: () {
                              },
                              child: Text("Contact Queuer"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(40),
                              ),
                              onPressed: () {
                              },
                              child: Text("Contact Client"),
                            ),
                          ],
                        )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(40),
                      ),
                      onPressed: () {
                        if(isVisible){
                          acceptOrder(widget.orderID!);
                          setState(() {
                            isVisible = false;
                          });
                        }
                        else {
                          orderisReady(widget.orderID!);
                        }

                      },
                      child: isVisible ? Text("ACCEPT ORDER") : Text("ORDER IS READY TO PICKUP"),
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: isVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8, top: 2, bottom: 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(40),
                        ),
                        onPressed: () {
                          declineOrder(widget.orderID!);
                        },
                        child: Text("DECLINE ORDER"),

                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}