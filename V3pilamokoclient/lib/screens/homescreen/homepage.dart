import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/homescreen/details/detail_screen.dart';
import 'package:v3pilamokoemall/screens/homescreen/details/order_screen.dart';
import 'package:v3pilamokoemall/screens/services/services_screen.dart';
import '../../global/global.dart';
import '../../splash screen/login.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

import '../dataHandler/emall_data.dart';
import '../menus_screen/menus_screen.dart';
import '../profilescreen/edit_profile.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double value = 5;

  Future<bool?> showWarning(BuildContext context) async{
    Navigator.push(context, MaterialPageRoute(builder: (c)=> ServiceScreen()));
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("paki-dala")
        .get()
        .then((snapshot){
      setState(() {
        pakiDalaPerKMfee = snapshot.data()!['PerKMFee'].toString();
        pakiDalaPlugRate = snapshot.data()!['PlugRate'].toString();
        pakiDalaBaseFee = snapshot.data()!['basefee'].toString();
      });
    }).whenComplete((){
      FirebaseFirestore.instance.collection("perDelivery")
          .doc("paki-bili")
          .get()
          .then((snapshot){
        pakibiliPerKM = snapshot.data()!['perkm'].toString();
        pakibiliplugrate = snapshot.data()!['plugRate'].toString();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
              ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10,),
                  if (zone.isNotEmpty) StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("pilamokoemall")
                          .where("zone", isEqualTo: zone)
                          .snapshots(),
                      builder: (context, snapshot)
                      {
                        return snapshot.hasData
                            ? snapshot.data!.size > 0
                              ? Column(
                      children: snapshot.data!.docs.map((document){
                        return InkWell(
                          onTap: (){
                            Emalldata? emalldata = Emalldata();
                            emalldata.pilamokosellerAvatarUrl = document['pilamokoemallAvatarUrl'];
                            emalldata.pilamokosellerEmail = document['pilamokoemallEmail'];
                            emalldata.pilamokosellerName = document['pilamokoemallName'];
                            emalldata.pilamokosellerUID = document['pilamokoemallUID'];
                            emalldata.shopName = document['shopName'];
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> MenusScreen(model: emalldata)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.blueAccent
                                    )
                                ),
                                width: MediaQuery.of(context).size.width * 8,
                                height: 100,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: SizedBox(
                                                height: 90,
                                                width: 80,
                                                child: Image.network(document['pilamokoemallAvatarUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                Text("Shop Name"),
                                                SizedBox(height: 10),
                                                Text(document['shopName']),
                                                SizedBox(height: 10),
                                                // RatingStars(
                                                //   value: value,
                                                //   onValueChanged: (v) {
                                                //     //
                                                //     setState(() {
                                                //       value = v;
                                                //     });
                                                //   },
                                                //   starBuilder: (index, color) => Icon(
                                                //     Icons.star,
                                                //     color: color,
                                                //   ),
                                                //   starCount: 5,
                                                //   starSize: 20,
                                                //   valueLabelColor: const Color(0xff9b9b9b),
                                                //   valueLabelTextStyle: const TextStyle(
                                                //       color: Colors.white,
                                                //       fontWeight: FontWeight.w300,
                                                //       fontStyle: FontStyle.normal,
                                                //       fontSize: 11),
                                                //   valueLabelRadius: 20,
                                                //   maxValue: 5,
                                                //   starSpacing: 2,
                                                //   maxValueVisibility: true,
                                                //   valueLabelVisibility: true,
                                                //   animationDuration: Duration(milliseconds: 1000),
                                                //   valueLabelPadding:
                                                //   const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                                //   valueLabelMargin: const EdgeInsets.only(right: 5),
                                                //   starOffColor: const Color(0xffe7e8ea),
                                                //   starColor: Colors.yellow,
                                                // ),

                                              ],
                                            ),
                                            SizedBox(width: MediaQuery.of(context).size.width * 0.14),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                        );
                      }).toList().cast()
                        )
                              : const Center(child: Text("No Sellers Yet"),)
                            : const Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Colors.blue,
                            ),
                          ),
                        );
                      }
                  ) else Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 250),
                    child: Column(
                      children: [
                        Text("Please Complete your profile to get products base on your zone"),
                        Container(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: ()
                            {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (c) => const EditProfile()));

                            },
                            child: const Center(
                              child: Text("OK"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}
