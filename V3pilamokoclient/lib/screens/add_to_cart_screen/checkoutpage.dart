import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:v3pilamokoemall/screens/homescreen/homescreen.dart';
import 'package:v3pilamokoemall/widgets/error_dialog.dart';
import 'package:v3pilamokoemall/widgets/loading_dialog.dart';

import '../../assistantMethods/assistant_methods.dart';
import '../../assistantMethods/cart_item_counter.dart';
import '../../assistantMethods/direction_details.dart';
import '../../assistantMethods/total_amount.dart';
import '../../global/global.dart';
import '../dataHandler/emall_data.dart';
import '../profilescreen/my_addressess.dart';


class CheckOutPage extends StatefulWidget {
  List<String>? checkItems;
  List<String>? sellerUID;
  CheckOutPage({this.checkItems,this.sellerUID});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController addresscontroller = TextEditingController();

  final List<String> genderItems = [
    'Cash on Delivery',
    'Top up Load',
  ];
  List<int>? separateItemQuantitiesList;
  num totalAmount = 0;
  int selectedValue =0;
  String payment = 'Cash on Delivery';
  List<String> seller =[];
  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    seller.clear();
    Provider.of<TotalAmount>(context, listen: false).displayTotalAmount(0);
    separateItemQuantitiesList = separateItemQuantities();
  }

  List<double> sellerLat=[];
  List<double> sellerLng=[];
  List<double> clientLat=[];
  List<double> clientLng=[];

  DirectionDetails? tripDirectionDetails;

  placeOrder() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    List<String> templist = ['garbageValue'];
    templist.addAll(widget.checkItems!);
    if (payment == "Cash on Delivery")
    {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c){
          return const LoadingDialog(message: "",);
        }
      );

      await FirebaseFirestore.instance
          .collection("orders")
          .doc(orderId)
          .set({
        "addressID": addresscontroller.text,
        "totalAmount" : totalAmount,
        "shippingFee" : AssistantMethods.calculateFaresEmall(tripDirectionDetails!),
        "orderBy": sharedPreferences!.getString("email"),
        "productIDs": templist,
        "paymentDetails": payment,
        "orderTime": orderId,
        "isSuccess": true,
        "serviceType": "emall",
        "zone": zone,
        "sellerUID": widget.sellerUID!.first,
        "riderUID": "",
        "status": "normal",
        "orderId": orderId,
      }).whenComplete((){
        updateCart(context, widget.checkItems!);

        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Order has benn placed successfully.");
        Navigator.push(context, MaterialPageRoute(builder: (context) => SideBarLayoutHome(page: 1,)));
      });
    }
    else {
      if(loadWallet > totalAmount){

        double newloadWallet = loadWallet - totalAmount;
        await FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .set({
          "addressID": addresscontroller.text,
          "totalAmount" : totalAmount,
          "shippingFee" : AssistantMethods.calculateFaresEmall(tripDirectionDetails!),
          "orderBy": sharedPreferences!.getString("email"),
          "productIDs": templist,
          "paymentDetails": payment,
          "orderTime": orderId,
          "isSuccess": true,
          "serviceType": "emall",
          "zone": zone,
          "sellerUID": widget.sellerUID!.first,
          "riderUID": "",
          "status": "normal",
          "orderId": orderId,
        }).whenComplete((){
          FirebaseFirestore.instance
              .collection("pilamokoclient")
              .doc(sharedPreferences!.getString("email"))
              .update({
            "loadWallet": newloadWallet
          }).whenComplete((){
            FirebaseFirestore.instance
                .collection("pilamokoemall")
                .doc(widget.sellerUID!.first)
                .update({
              "loadWallet": totalAmount
            }).whenComplete((){
              updateCart(context, widget.checkItems!);

              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Order has been placed successfully.");
              Navigator.push(context, MaterialPageRoute(builder: (context) => SideBarLayoutHome(page: 1,)));
            });
          });
        });
      }
    }
  }

  Future<void> getDirectionalDetails(double sellerLat, double sellerLng, double clientLat, double clientLng)async {

    var pickUpLatLng = LatLng(sellerLat, sellerLng);
    var dropOffLatLng = LatLng(clientLat, clientLng);

    var details = await AssistantMethods.obtainDirectionDetails(pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: const EdgeInsets.only(
              top: 10,
              right: 8,
              left: 8,
              bottom: 8,
            ),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(thickness: 1, color: Colors.grey,),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("pilamokoclient")
                            .doc(sharedPreferences!.getString("email")!)
                            .collection("myDeliveryAddresses")
                            .where("status", isEqualTo: 'In use')
                            .snapshots(),
                        builder: (c, snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data!.size > 0){
                              return Column(
                                children: snapshot.data!.docs.map((document) {
                                  clientLat.add(document['lat']);
                                  clientLng.add(document['lng']);
                                  addresscontroller.text = document.id;
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (c)=> MyAddressess(addressID: document.id,)));
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      child: Stack(
                                        children: [
                                          const Icon(Icons.location_on, color: Colors.blue,),
                                          Positioned(
                                            left: 35,
                                            top: 2,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Delivery Address",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                                const SizedBox(height: 5,),
                                                Text(
                                                  "${document['name']} | ${document['phone']}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                                Text(
                                                  document['address'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Positioned(
                                            top: 10,
                                            right: 1,
                                            child: Icon(Icons.arrow_right,),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                            else {
                              return InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (c)=> MyAddressess()));
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: Stack(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.blue,),
                                      Positioned(
                                        left: 35,
                                        top: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Delivery Address",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              "Set your Delivery address",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Positioned(
                                        top: 10,
                                        right: 1,
                                        child: Icon(Icons.arrow_right,),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          }
                          else {
                            return Center(child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 12),
                              child: const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.blue,
                                ),
                              ),
                            ),);
                          }
                        },
                      ),
                      const Divider(thickness: 1, color: Colors.grey,),
                      const SizedBox(height: 10),
                      ListView.builder(
                        itemCount: widget.sellerUID!.length,
                        shrinkWrap: true,
                        itemBuilder: (c, index){
                          return Column(
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("pilamokoemall")
                                    .doc(widget.sellerUID![index])
                                    .get(),
                                builder: (c, snapshot){
                                  Map? data;
                                  if(snapshot.hasData){
                                    data = snapshot.data!.data()! as Map<String, dynamic>;
                                    sellerLat.add(data['lat']);
                                    sellerLng.add(data['lng']);
                                    getDirectionalDetails(sellerLat[index], sellerLng[index], clientLat[index], clientLng[index]);

                                  }
                                  return Container();
                                },
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance.collection("items")
                                    .where("itemID", whereIn: separateItemIDs2(widget.checkItems!))
                                    .where("pilamokoemallUID", isEqualTo: widget.sellerUID![index])
                                    .snapshots(),
                                builder: (c, snapshot){
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
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              const Icon(CommunityMaterialIcons.storefront_outline),
                                              Text(model.shopName!,
                                                style: const TextStyle(
                                                    fontSize: 18
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5,),
                                          Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color: Colors.blueAccent
                                                  )
                                              ),
                                              width: MediaQuery.of(context).size.width * 8,
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      // Navigator.push(context, MaterialPageRoute(builder: (c)=>  AddtoCartDetailScreen()));
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
                                                            Text(model.title!),
                                                            const SizedBox(height: 10),
                                                            Text("Qty: ${separateItemQuantitiesList![index]}"),
                                                            const SizedBox(height: 10),
                                                          ],
                                                        ),
                                                        SizedBox(width: MediaQuery.of(context).size.width * 0.14),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            const SizedBox(height: 10),
                                                            Text("₱ ${model.price!}"),
                                                            const SizedBox(height: 10),
                                                            const SizedBox(height: 10),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),

                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1, color: Colors.grey,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Item Price:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Consumer2<TotalAmount, CartItemCounter>(builder: (context, amountProvider, cartProvider, c)
                          {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: cartProvider.count == 0
                                    ? Container()
                                    : Text(
                                  "₱ ${amountProvider.tAmount}",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Shipping Fee:",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (tripDirectionDetails != null) ? '₱ ${AssistantMethods.calculateFaresEmall(tripDirectionDetails!)}': '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Colors.grey,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Payment Method",
                            style: TextStyle(color: Colors.blueAccent, fontSize: 19),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.10,),
                          Column(
                            children: [
                              SizedBox(
                                height: 45,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.

                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select Payment Method',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 30,
                                  buttonHeight: 60,
                                  buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  items: genderItems.map((item) =>
                                      DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                      .toList(),
                                  onChanged: (value){
                                    setState(() {
                                      payment = value!;
                                    });
                                  },
                                  value: payment,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return 'Select Payment Method';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Colors.grey,),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (tripDirectionDetails != null) ? '₱ ${(totalAmount + AssistantMethods.calculateFaresEmall(tripDirectionDetails!))}': '',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          if(addresscontroller.text.isEmpty){
                            showDialog(
                              context: context,
                              builder: (c){
                                return const ErrorDialog(message: 'Please Select delivery address',);
                              }
                            );
                          }
                          else {
                            placeOrder();
                            // updateCart(context, widget.checkItems!);
                          }
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
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text("Place Order",
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
                ),
              ],
            )
        ),
      ),
    );
  }
}
