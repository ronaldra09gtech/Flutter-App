import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/assistantMethods/cart_item_counter.dart';
import 'package:plmclient/client/assistantMethods/total_amount.dart';
import 'package:plmclient/client/mainScreens/address_screen.dart';
import 'package:plmclient/client/models/eresto/eresto_items.dart';
import 'package:plmclient/client/splashScreen/splashScreen.dart';
import 'package:plmclient/client/widgets/cart_item_design.dart';
import 'package:plmclient/client/widgets/progress_bar.dart';
import 'package:plmclient/client/widgets/text_widget_header.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {

  final String? pilamokosellerUID;

  CartScreen({this.pilamokosellerUID});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
{
  List<int>? separateItemQuantitiesList;
  num totalAmount = 0;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantitiesList = separateItemQuantities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
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
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreenClient()));
          },
        ),
        title: const Text(
          "Pilamoko",
          style: TextStyle(fontSize: 45, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white,),
                onPressed: ()
                {
                  print("click");
                },
              ),
              Positioned(
                child: Stack(
                  children:  [
                    const Icon(
                      Icons.brightness_1,
                      size: 20.0,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      right: 4,
                      child: Center(
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, c)
                          {
                            return Text(
                                counter.count.toString(),
                                style: const TextStyle(color: Colors.white, fontSize: 12)
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 10,),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: const Text("Clear Cart", style: TextStyle(fontSize: 16)),
              backgroundColor: Colors.blueAccent,
              icon: const Icon(Icons.clear_all),
              onPressed: ()
              {
                clearCartNow(context);
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreenClient()));

                Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              label: const Text("Check Out", style: TextStyle(fontSize: 16)),
              backgroundColor: Colors.blueAccent,
              icon: const Icon(Icons.navigate_next),
              onPressed: ()
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c)=> AddressScreen(
                      totalAmount: totalAmount.toDouble(),
                      pilamokosellerUID: widget.pilamokosellerUID,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          //overall total amount
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(title: "My Cart List")
          ),

          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
            {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                    "Total Price: ₱" + amountProvider.tAmount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),

          //display cart items with quantity number
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("items")
                .where("itemID", whereIn: separateItemIDs())
                .orderBy("publishDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                  : snapshot.data!.docs.length == 0
                  ? //startBuildingCart()
              Container()
                  : SliverList(
                delegate: SliverChildBuilderDelegate((context, index)
                {
                  ErestoItems model = ErestoItems.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );

                  if(index == 0)
                  {
                    totalAmount = 0;
                    totalAmount = totalAmount + (model.price! * separateItemQuantitiesList![index]);
                  }
                  else
                  {
                    totalAmount = totalAmount + (model.price! * separateItemQuantitiesList![index]);
                  }

                  if(snapshot.data!.docs.length - 1 == index)
                  {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp)
                    {
                      Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(totalAmount.toDouble());
                    });
                  }

                  return CartItemDesign(
                    model: model,
                    context: context,
                    quanNumber: separateItemQuantitiesList![index],
                  );
                },
                  childCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
