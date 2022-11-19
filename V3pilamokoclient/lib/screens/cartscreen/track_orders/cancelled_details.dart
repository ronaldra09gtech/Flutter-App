import 'package:flutter/material.dart';

class CancelledDetailsScreen extends StatelessWidget {
  const CancelledDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.only(top: 50, right: 8, left: 8, bottom: 8,),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text("Details",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey,),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Product Name"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                    const Text("Yamato Action Figure")
                  ],
                ),
                const Divider(color: Colors.grey,),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Store Name"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.19,),
                    const Text("One Piece Store ")
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey,),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Price"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.32),
                    const Text("899.99")
                  ],
                ),
                const Divider(color: Colors.grey,),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Qty"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.341,),
                    const Text("3")
                  ],
                ),
                const Divider(color: Colors.grey,),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Description"),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.20,),
                    const Expanded(child: Text("Sideshow and Bandai Spirits Ichibansho is proud to announce the Yamato (Glitter of Ha) Collectible Figure! This statue is expertly crafted and meticulously sculpted to look like Yamato from their respective anime. Standing at approximately 7.9 tall, Yamato is seen in their popular pose. Be sure to collect this and enhance your display with other incredible Ichibansho figures!"))
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ],
            )
        ),
      ),
    );
  }
}
