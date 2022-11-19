import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/widget/search_widget.dart';
import 'package:v3pilamokoemall/widgets/error_dialog.dart';

import '../../global/global.dart';


class DocuFilingAssistance extends StatefulWidget {
  const DocuFilingAssistance({Key? key}) : super(key: key);

  @override
  State<DocuFilingAssistance> createState() => _DocuFilingAssistanceState();
}

class _DocuFilingAssistanceState extends State<DocuFilingAssistance> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController notesController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  double? dropOffAddressLat;
  double? dropOffAddressLng;
  String? dropoffplaceID;
  String? dropofflocation;

  createbooking() async {
    String orderId = DateTime.now().millisecondsSinceEpoch.toString();

    await FirebaseFirestore.instance.collection("docufilling")
        .doc(orderId).set({
      "dropoffaddress": dropofflocation,
      "dropoffaddressLat": dropOffAddressLat,
      "dropoffaddressLng": dropOffAddressLng,
      "notes": notesController.text,
      // "paymentMethods": widget.payment,
      "phoneNum": phoneController.text,
      // "price": AssistantMethods.calculateFares(tripDirectionDetails!),
      "orderTime": orderId,
      "zone": zone,
      "isSuccess": true,
      "clientUID": sharedPreferences!.getString("email"),
      "riderUID": "",
      "status": "normal",
      "bookID": orderId,
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/logo.PNG",
                        height: 40,
                        width: 40,
                      ),
                      Text("Document Filing Assistance",
                        style: TextStyle(
                            fontSize: 23,
                            color: Colors.blueAccent.shade400
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text("Please Write the Following Documents here!",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.60,
                    width: MediaQuery.of(context).size.width * 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blueAccent.shade400,
                        )
                    ),
                    child: TextFormField(
                      controller: notesController,
                      expands: true,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: InputBorder.none
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "This Field is Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: SearchLocation(
                      apiKey: "AIzaSyAveoqLGZ5EfEAvGL_JaDvJjCR6KVgufUM",
                      country: 'ph',
                      language: 'ph',
                      icon: Icons.pin_drop_outlined,
                      placeholder: "Set Drop off Location",
                      hasClearButton: true,
                      onSelected: (Place place) async {
                        final geolocation = await place.geolocation;
                        final latlng = LatLng(geolocation!.coordinates.latitude, geolocation.coordinates.longitude);
                        dropoffplaceID = place.placeId;
                        dropOffAddressLat = latlng.latitude;
                        dropOffAddressLng = latlng.longitude;
                        dropofflocation = place.description;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blueAccent.shade400,
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10
                      ),
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                            hintText: "Phone Number",
                            border: InputBorder.none
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "This Field is Required";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: (){
                      if(_formKey.currentState!.validate()){
                        if(dropoffplaceID == null){
                          showDialog(
                            context: context,
                            builder: (c){
                              return ErrorDialog(message: "Please set drop off address",);
                            }
                          );
                        }
                        else {
                          createbooking();
                        }
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.blueAccent.shade400
                            )
                        ),
                        child: const Text("Submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 20
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}