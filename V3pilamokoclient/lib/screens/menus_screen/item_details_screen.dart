import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:v3pilamokoemall/screens/homescreen/homescreen.dart';

import '../../assistantMethods/assistant_methods.dart';
import '../../assistantMethods/cart_item_counter.dart';
import '../add_to_cart_screen/add_cart_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  QueryDocumentSnapshot? document;
  String? shopName;
  ItemDetailScreen({this.document,this.shopName});
  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  final List<String> genderItems = [
    'COD',
    'Top up Load',
  ];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  int _count = 0;

  void _incrementCount(){
    if(_count < 10){
      setState(() {
        _count++;
      });
    }
  }
  void _decrementCount(){
    if(_count > 0){
      setState(() {
        _count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(
              top: 50,
              right: 8,
              left: 8,
              bottom: 8,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Details",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart, color: Colors.blue,),
                          onPressed: ()
                          {
                            //send to cart Screen
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> SideBarLayoutHome(page: 3,)));
                          },
                        ),
                        Positioned(
                          right: 1,
                          child: Stack(
                            children:  [
                              const Icon(
                                Icons.brightness_1,
                                size: 20.0,
                                color: Colors.blue,
                              ),
                              Positioned(
                                top: 5,
                                right: 6,
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
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(widget.document!['thumbnailUrl'],
                      height: 180,
                    )
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Name"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                    Text("${widget.document!['title']}")
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Store Name"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.19,),
                    Text("${widget.shopName} ")
                  ],
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.32),
                    Text("₱ ${widget.document!['price']}")
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Qty"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.341,),
                    Container(
                      height: 25,
                      width: 25,
                      child: FloatingActionButton(
                        child: Icon(Icons.remove),
                        onPressed: _decrementCount,

                      ),
                    ),
                    SizedBox(width: 10),
                    Text("$_count"),
                    SizedBox(width: 10),
                    Container(
                      height: 25,
                      width: 25,
                      child: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: _incrementCount,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Description"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.20,),
                    Expanded(child: Text("${widget.document!['longDescription']}"))
                  ],
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        //formValidation();
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
                        width: (MediaQuery.of(context).size.width /2)-20,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text("Order now",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: (){
                        int itemCounter = _count;

                        List<String> separateItemIDList = separateItemIDs();

                        //if - check if item exist already in cart
                        separateItemIDList.contains(widget.document!['itemID'])
                            ? Fluttertoast.showToast(msg: "Item is already in Cart.")
                            :
                        //else - add to card
                        addItemToCard(widget.document!['itemID'], context, itemCounter);

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
                        width: (MediaQuery.of(context).size.width /2)-20,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text("Add to cart",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent.shade400,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}
