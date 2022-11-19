import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/home_screen.dart';
import 'package:plmclient/client/widgets/error_dialog.dart';

import '../../main.dart';

class PlaceOrderScreen extends StatefulWidget {

  String? addressID, sellerUID;
  double? totalAmount;

  PlaceOrderScreen({this.addressID,this.totalAmount,this.sellerUID});

  @override
  _PlaceOrderScreenState createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen>
{
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  bool seller = false;
  bool emall = false;
  bool market = false;

  String? valueChoose;
  List listItem = [
    "Cash on Delivery","Topup Load"
  ];



  Future addOrderDetails() async
  {
      await FirebaseFirestore.instance
          .collection("pilamokoseller")
          .doc(widget.sellerUID)
          .get()
          .then((sellerdata) async{
        if(sellerdata.exists){
          setState(() {
            seller = true;
          });
        }
        else{
          await FirebaseFirestore.instance
              .collection("pilamokoemall")
              .doc(widget.sellerUID)
              .get()
              .then((emalldata) async {
            if(emalldata.exists){
              setState(() {
                emall = true;
              });
            }
            else{
              await FirebaseFirestore.instance
                  .collection("pilamokoemarket")
                  .doc(widget.sellerUID)
                  .get()
                  .then((emarketdata){
                if(emarketdata.exists){
                  setState(() {
                    market = true;
                  });
                }
              });
            }
          });
        }
      });

      double? totalamount = widget.totalAmount;
      double newloadWallet = double.parse(loadWallet) - totalamount!;
      if(seller){
      if(valueChoose == "Topup Load")
      {
        if(double.parse(loadWallet) > totalamount)
        {
          writeOrderDetailsForUser({
            "addressID": widget.addressID,
            "totalAmount" : totalamount,
            "orderBy": sharedPreferences!.getString("email"),
            "productIDs": sharedPreferences!.getStringList("userCart"),
            "paymentDetails": valueChoose,
            "orderTime": orderId,
            "isSuccess": true,
            "serviceType": "eresto",
            "zone": zone,
            "sellerUID": widget.sellerUID,
            "riderUID": "",
            "status": "normal",
            "orderId": orderId,
          }).then((value){
            FirebaseFirestore.instance
                .collection("pilamokoclient")
                .doc(sharedPreferences!.getString("email"))
                .update({
              "loadWallet": newloadWallet
            });
          });

          writeOrderDetailsForSellers({
            "addressID": widget.addressID,
            "totalAmount" : totalamount,
            "orderBy": sharedPreferences!.getString("email"),
            "productIDs": sharedPreferences!.getStringList("userCart"),
            "paymentDetails": valueChoose,
            "orderTime": orderId,
            "isSuccess": true,
            "serviceType": "eresto",
            "zone": zone,
            "sellerUID": widget.sellerUID,
            "riderUID": "",
            "status": "normal",
            "orderId": orderId,
          }).whenComplete((){
            clearCartNow(context);
            setState(() {
              orderId="";
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              Fluttertoast.showToast(msg: "Congratulations, order has benn placed successfully.");
            });
          });
        }
        else
        {
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: "Not enough load!",
                );
              }
          );
        }
      }
      else if (valueChoose == "Cash on Delivery")
      {

        writeOrderDetailsForUser({
          "addressID": widget.addressID,
          "totalAmount" : widget.totalAmount,
          "orderBy": sharedPreferences!.getString("email"),
          "productIDs": sharedPreferences!.getStringList("userCart"),
          "paymentDetails": valueChoose,
          "orderTime": orderId,
          "isSuccess": true,
          "serviceType": "eresto",
          "zone": zone,
          "sellerUID": widget.sellerUID,
          "riderUID": "",
          "status": "normal",
          "orderId": orderId,
        });

        writeOrderDetailsForSellers({
          "addressID": widget.addressID,
          "totalAmount" : widget.totalAmount,
          "orderBy": sharedPreferences!.getString("email"),
          "productIDs": sharedPreferences!.getStringList("userCart"),
          "paymentDetails": valueChoose,
          "orderTime": orderId,
          "isSuccess": true,
          "serviceType": "eresto",
          "zone": zone,
          "sellerUID": widget.sellerUID,
          "riderUID": "",
          "status": "normal",
          "orderId": orderId,
        }).whenComplete((){
          clearCartNow(context);
          setState(() {
            orderId="";
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            Fluttertoast.showToast(msg: "Congratulations, order has benn placed successfully.");
          });
        });
      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please provide payment method.",
              );
            }
        );
      }


    }
    else if(emall){
        if(valueChoose =="Topup Load")
        {
          if(double.parse(loadWallet) > totalamount)
          {
            writeOrderDetailsForUser({
              "addressID": widget.addressID,
              "totalAmount" : widget.totalAmount,
              "orderBy": sharedPreferences!.getString("email"),
              "productIDs": sharedPreferences!.getStringList("userCart"),
              "paymentDetails": valueChoose,
              "orderTime": orderId,
              "isSuccess": true,
              "serviceType": "emall",
              "zone": zone,
              "sellerUID": widget.sellerUID,
              "riderUID": "",
              "status": "normal",
              "orderId": orderId,
            }).then((value){
              FirebaseFirestore.instance
                  .collection("pilamokoclient")
                  .doc(sharedPreferences!.getString("email"))
                  .update({
                "loadWallet": newloadWallet
              });
            });

            writeOrderDetailsForSellers({
              "addressID": widget.addressID,
              "totalAmount" : widget.totalAmount,
              "orderBy": sharedPreferences!.getString("email"),
              "productIDs": sharedPreferences!.getStringList("userCart"),
              "paymentDetails": valueChoose,
              "orderTime": orderId,
              "isSuccess": true,
              "serviceType": "emall",
              "zone": zone,
              "sellerUID": widget.sellerUID,
              "riderUID": "",
              "status": "normal",
              "orderId": orderId,
            }).whenComplete((){
              clearCartNow(context);
              setState(() {
                orderId="";
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                Fluttertoast.showToast(msg: "Congratulations, order has benn placed successfully.");
              });
            });
          }
          else
          {
            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "Not enough load!",
                  );
                }
            );
          }
        }
        else if (valueChoose == "Cash on Delivery")
        {
          writeOrderDetailsForUser({
            "addressID": widget.addressID,
            "totalAmount" : widget.totalAmount,
            "orderBy": sharedPreferences!.getString("email"),
            "productIDs": sharedPreferences!.getStringList("userCart"),
            "paymentDetails": valueChoose,
            "orderTime": orderId,
            "isSuccess": true,
            "serviceType": "emall",
            "zone": zone,
            "sellerUID": widget.sellerUID,
            "riderUID": "",
            "status": "normal",
            "orderId": orderId,
          });

          writeOrderDetailsForSellers({
            "addressID": widget.addressID,
            "totalAmount" : widget.totalAmount,
            "orderBy": sharedPreferences!.getString("email"),
            "productIDs": sharedPreferences!.getStringList("userCart"),
            "paymentDetails": valueChoose,
            "orderTime": orderId,
            "isSuccess": true,
            "serviceType": "emall",
            "zone": zone,
            "sellerUID": widget.sellerUID,
            "riderUID": "",
            "status": "normal",
            "orderId": orderId,
          }).whenComplete((){
            clearCartNow(context);
            setState(() {
              orderId="";
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              Fluttertoast.showToast(msg: "Congratulations, order has benn placed successfully.");
            });
          });
        }
        else
        {
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: "Please provide payment method.",
                );
              }
          );
        }

    }
    else if(market){
        if(valueChoose =="Topup Load")
        {
          if(double.parse(loadWallet) > totalamount)
          {
            writeOrderDetailsForUser({
              "addressID": widget.addressID,
              "totalAmount" : widget.totalAmount,
              "orderBy": sharedPreferences!.getString("email"),
              "productIDs": sharedPreferences!.getStringList("userCart"),
              "paymentDetails": valueChoose,
              "orderTime": orderId,
              "isSuccess": true,
              "serviceType": "emarket",
              "zone": zone,
              "sellerUID": widget.sellerUID,
              "riderUID": "",
              "status": "normal",
              "orderId": orderId,
            }).then((value){
              FirebaseFirestore.instance
                  .collection("pilamokoclient")
                  .doc(sharedPreferences!.getString("email"))
                  .update({
                "loadWallet": newloadWallet
              });
            });

            writeOrderDetailsForSellers({
              "addressID": widget.addressID,
              "totalAmount" : widget.totalAmount,
              "orderBy": sharedPreferences!.getString("email"),
              "productIDs": sharedPreferences!.getStringList("userCart"),
              "paymentDetails": valueChoose,
              "orderTime": orderId,
              "isSuccess": true,
              "serviceType": "emarket",
              "zone": zone,
              "sellerUID": widget.sellerUID,
              "riderUID": "",
              "status": "normal",
              "orderId": orderId,
            }).whenComplete((){
              clearCartNow(context);
              setState(() {
                orderId="";
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                Fluttertoast.showToast(msg: "Congratulations, order has benn placed successfully.");
              });
            });
          }
          else
          {
            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "Not enough load!",
                  );
                }
            );
          }

        }
        else if (valueChoose =="Cash on Delivery")
        {
          writeOrderDetailsForUser({
            "addressID": widget.addressID,
            "totalAmount" : widget.totalAmount,
            "orderBy": sharedPreferences!.getString("email"),
            "productIDs": sharedPreferences!.getStringList("userCart"),
            "paymentDetails": valueChoose,
            "orderTime": orderId,
            "isSuccess": true,
            "serviceType": "emarket",
            "zone": zone,
            "sellerUID": widget.sellerUID,
            "riderUID": "",
            "status": "normal",
            "orderId": orderId,
          });

          writeOrderDetailsForSellers({
            "addressID": widget.addressID,
            "totalAmount" : widget.totalAmount,
            "orderBy": sharedPreferences!.getString("email"),
            "productIDs": sharedPreferences!.getStringList("userCart"),
            "paymentDetails": valueChoose,
            "orderTime": orderId,
            "isSuccess": true,
            "serviceType": "emarket",
            "zone": zone,
            "sellerUID": widget.sellerUID,
            "riderUID": "",
            "status": "normal",
            "orderId": orderId,
          }).whenComplete((){
            clearCartNow(context);
            setState(() {
              orderId="";
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              Fluttertoast.showToast(msg: "Congratulations, order has benn placed successfully.");
            });
          });
        }
        else
        {
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: "Please provide payment method.",
                );
              }
          );
        }

    }
    else{
      setState(() {
        orderId="";
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        Fluttertoast.showToast(msg: "There's an Error.");
      });
    }
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSellers(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  @override
  Widget build(BuildContext context)
  {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/delivery.jpg"),

            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Text("Payment Method"),
                  ),
                  Expanded(
                    child: DropdownButton(
                      value: valueChoose,
                      onChanged: (newValue){
                        setState(() {
                          valueChoose = newValue as String?;
                        });
                        print(valueChoose);
                      },
                      items: listItem.map((valueItem){
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text("Place Order"),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
              ),
              onPressed: ()
              {
                addOrderDetails();
              },
            )

          ],
        ),
      ),
    );
  }
}
