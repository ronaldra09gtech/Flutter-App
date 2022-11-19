import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/dataHandler/emall_data.dart';

class AddtoCartDetailScreen extends StatefulWidget {
  EmallItems? document;
  String? shopName;
  AddtoCartDetailScreen({this.document,this.shopName});

  @override
  State<AddtoCartDetailScreen> createState() => _AddtoCartDetailScreenState();
}

class _AddtoCartDetailScreenState extends State<AddtoCartDetailScreen> {
  final List<String> genderItems = [
    'COD',
    'Top up Load',
  ];

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.only(top: 50, right: 8, left: 8, bottom: 8,),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(widget.document!.thumbnailUrl!,
                        height: 180,
                      )
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
                      Text("${widget.document!.title}")
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
                      Text("${widget.shopName} ")
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
                      Text("₱ ${widget.document!.price}")
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
                      Expanded(child: Text("${widget.document!.longDescription}"))
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey,),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
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
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text("Back",
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
