import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/cartscreen/track_orders/pending_details.dart';
import '../screens/dataHandler/emall_data.dart';

class OrderCart extends StatelessWidget {

  final int? itemCount;
  final List<DocumentSnapshot>? data;
  final String? orderID;
  final List<String>? seperateQuantitiesList;

  OrderCart({
    this.seperateQuantitiesList,
    this.orderID,
    this.data,
    this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      height: itemCount! * 170,
      child: ListView.builder(
        itemCount: itemCount,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index)
        {
          EmallItems model = EmallItems.fromJson(data![index].data()! as Map<String, dynamic>);
          return placeOrderDesignWidget(model, context, seperateQuantitiesList![index]);
        },
      ),
    );
  }
}

Widget placeOrderDesignWidget(EmallItems model, BuildContext context, separateQuantitiesList)
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10,),
      Row(
        children: [
          Icon(CommunityMaterialIcons.storefront_outline),
          Text(model.shopName!,
            style: TextStyle(
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
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>  const PendingDetailScreen()));
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
                        Text("Qty: $separateQuantitiesList"),
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
}
multiply(double price, double quantity){
  double total=0;
  total = price * quantity;
  return total.toString();
}