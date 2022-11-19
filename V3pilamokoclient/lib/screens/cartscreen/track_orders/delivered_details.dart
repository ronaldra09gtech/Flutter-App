import 'package:flutter/material.dart';

class DeliveredDetailScreen extends StatelessWidget {
  const DeliveredDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    children: [
                      Text("Details",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
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
                      Text("Product Name"),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                      Text("Yamato Action Figure")
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
                      Text("One Piece Store ")
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
                      Text("899.99")
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
                      Text("Qty"),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.341,),
                      Text("3")
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
                      Expanded(child: Text("Sideshow and Bandai Spirits Ichibansho is proud to announce the Yamato (Glitter of Ha) Collectible Figure! This statue is expertly crafted and meticulously sculpted to look like Yamato from their respective anime. Standing at approximately 7.9 tall, Yamato is seen in their popular pose. Be sure to collect this and enhance your display with other incredible Ichibansho figures!"))
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                ],
              )
          ),
        ),
      ),
    );
  }
}
