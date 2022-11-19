import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/models/emall/emall_items.dart';
import 'package:plmclient/client/widgets/app_bar.dart';

class EmallItemDetailsScreen extends StatefulWidget
{
  final EmallItems? model;
  EmallItemDetailsScreen({this.model});

  @override
  _EmallItemDetailsScreenState createState() => _EmallItemDetailsScreenState();
}

class _EmallItemDetailsScreenState extends State<EmallItemDetailsScreen> {

  TextEditingController counterTextEditingController = TextEditingController();



  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: MyAppBar(pilamokosellerUID: widget.model!.pilamokosellerUID),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: [
            Image.network(
                widget.model!.thumbnailUrl.toString(),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NumberInputPrefabbed.roundedButtons(
                controller: counterTextEditingController,
                incDecBgColor: Colors.lightBlueAccent,
                min: 1,
                max: 10,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,

              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "₱ " + widget.model!.price.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

            const SizedBox(height: 15,),


            Center(
              child: InkWell(
                onTap: ()
                {
                  int itemCounter = int.parse(counterTextEditingController.text);

                  List<String> separateItemIDList = separateItemIDs();

                  //if - check if item exist already in cart
                  separateItemIDList.contains(widget.model!.itemID)
                      ? Fluttertoast.showToast(msg: "Item is already in Cart.")
                      :
                  //else - add to card
                  addItemToCard(widget.model!.itemID, context, itemCounter);

                },
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
                  width: MediaQuery.of(context).size.width -11,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
