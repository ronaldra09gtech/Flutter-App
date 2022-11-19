import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/splash%20screen/dropdown_button.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  final List<String> genderItems = [
    'COD',
    'Top up Load',
  ];

  String? selectedValue;

  final _formKey = GlobalKey<FormState>();

  int _count = 0;

  void _incrementCount(){
    setState(() {
      _count++;
    });
  }
  void _decrementCount(){
    setState(() {
      _count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                top: 20,
                right: 8,
                left: 8,
                bottom: 8,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/yamato1.jpeg",
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Qty"),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.341,),
                      Container(
                        height: 25,
                        width: 25,
                        child: FloatingActionButton(
                          child: Icon(Icons.add),
                            onPressed: _incrementCount,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("$_count"),
                      SizedBox(width: 10),
                      Container(
                        height: 25,
                        width: 25,
                        child: FloatingActionButton(
                            child: Icon(Icons.remove),
                            onPressed: _decrementCount,

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
                      Expanded(child: Text("Sideshow and Bandai Spirits Ichibansho is proud to announce the Yamato (Glitter of Ha) Collectible Figure! This statue is expertly crafted and meticulously sculpted to look like Yamato from their respective anime. Standing at approximately 7.9 tall, Yamato is seen in their popular pose. Be sure to collect this and enhance your display with other incredible Ichibansho figures!"))
                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),

                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                      width: double.maxFinite,
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
                ],
              )
          ),
        ),
      ),
    );
  }
}
