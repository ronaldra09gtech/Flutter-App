import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:v3pilamokoemall/screens/add_to_cart_screen/add_cart_details.dart';
import 'package:v3pilamokoemall/screens/dataHandler/emall_data.dart';
import 'package:v3pilamokoemall/screens/add_to_cart_screen/checkoutpage.dart';
import '../../assistantMethods/assistant_methods.dart';
import '../../assistantMethods/cart_item_counter.dart';
import '../../assistantMethods/total_amount.dart';


class AddCartScreen extends StatefulWidget {
  const AddCartScreen({Key? key}) : super(key: key);

  @override
  State<AddCartScreen> createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {

  List<int>? separateItemQuantitiesList;
  num totalAmount = 0;
  List<bool> _isChecked=[];
  int count = 0;
  bool loading = true;

  List<String> checkItems =[];
  List<String> sellerID =[];

  getData(){
    FirebaseFirestore.instance
        .collection("items")
        .where("itemID", whereIn: separateItemIDs())
        .get()
        .then((snapshot){
          count = snapshot.size;
    }).whenComplete((){
      setState((){
        loading = false;
        _isChecked = List<bool>.filled(count, false);
      });
    });


  }
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantitiesList = separateItemQuantities();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: SizedBox(
          height: 30,
          child: FloatingActionButton.extended(
            onPressed: (){
              if(sellerID.length ==1){
                Navigator.push(context, MaterialPageRoute(builder: (c) => CheckOutPage(checkItems: checkItems, sellerUID: sellerID,)));
              }
              else {
                Fluttertoast.showToast(
                  msg: "Please select items from a single store",
                  backgroundColor: Colors.redAccent
                );
              }
            },
            label: const Text("CheckOut",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300
            ),
            ),
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text("My Cart List",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                loading
                    ? Container()
                    : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID", whereIn: separateItemIDs())
                      .orderBy("publishDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot)
                  {
                    return !snapshot.hasData
                        ? Center(child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 12),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.blue,
                        ),
                      ),
                    ),)
                        : snapshot.data!.docs.length == 0
                        ? //startBuildingCart()
                    Container()
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index){
                        EmallItems model = EmallItems.fromJson(
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
                        return Padding(
                          padding: const EdgeInsets.only(top: 3, left: 10, right: 10,),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _isChecked[index],
                                onChanged: (val) {
                                  var boool = val!;
                                  if(boool){
                                    String combined = "${model.itemID!}:${separateItemQuantitiesList![index]}";
                                    checkItems.add(combined);
                                    if(sellerID.contains(model.pilamokosellerUID!)){
                                    }
                                    else {
                                      sellerID.add(model.pilamokosellerUID!);
                                    }
                                  }
                                  else {
                                    String combined = "${model.itemID!}:${separateItemQuantitiesList![index]}";
                                    checkItems.removeWhere((item) => item == combined);
                                    sellerID.removeWhere((item) => item == model.pilamokosellerUID!);

                                  }
                                  setState(() {
                                      _isChecked[index] = val;
                                    },
                                  );
                                },
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.blueAccent)
                                  ),
                                  width: MediaQuery.of(context).size.width * .8,
                                  height: 100,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (c)=>  AddtoCartDetailScreen(document: model,shopName: model.shopName,)));
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: SizedBox(
                                                    height: 90,
                                                    width: 80,
                                                    child: Image.network(model.thumbnailUrl!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    Text("Prodoct name: ${model.title!}"),
                                                    const SizedBox(height: 10),
                                                    Text("Store Name: ${model.shopName!}"),
                                                    const SizedBox(height: 10),
                                                    Text("Qty: ${separateItemQuantitiesList![index]}"),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 20,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Text("₱ ${model.price!}"),
                                                const SizedBox(height: 10),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: IconButton(
                                              icon: const Icon(CommunityMaterialIcons.trash_can, color: Colors.red),
                                              onPressed: (){
                                                // sharedPreferences!.setStringList("userCart", ['garbageValue']);
                                                removeItemfromCart(context, model.itemID!, separateItemQuantitiesList![index].toString());
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
            Positioned(
              bottom:10,
              right:MediaQuery.of(context).size.width /3.25,
              child: Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
              {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                      "Total Price(All items in cart): ₱${amountProvider.tAmount}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
