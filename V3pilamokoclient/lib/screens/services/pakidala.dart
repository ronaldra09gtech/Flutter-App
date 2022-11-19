import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:search_map_location/widget/search_widget.dart';
import 'package:v3pilamokoemall/global/global.dart';
import 'package:v3pilamokoemall/screens/services/pakidala_details.dart';
import 'package:v3pilamokoemall/widgets/error_dialog.dart';




class Pakidala extends StatefulWidget {
  const Pakidala({Key? key}) : super(key: key);

  @override
  State<Pakidala> createState() => _PakidalaState();
}

class _PakidalaState extends State<Pakidala> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController notesController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController senderController = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController weight = TextEditingController();
  List<String> _payment = ['COD', 'Top-up Load']; // Option 1
  String _selectedPayment = 'COD'; // Option 1

  double? pickUpAddressLat;
  double? pickUpAddressLng;
  double? dropOffAddressLat;
  double? dropOffAddressLng;
  String? dropoffplaceID;
  String? pickupplaceID;
  String? pickuplocation;
  String? dropofflocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.text = sharedPreferences!.getString("phone")!;
    senderController.text = sharedPreferences!.getString("name")!;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        Text("Paki-Dala",
                          style: TextStyle(
                              fontSize: 23,
                              color: Colors.blueAccent.shade400
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Text("Please write the Following items here!",
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
                        expands: true,
                        maxLines: null,
                        controller: notesController,
                        decoration: const InputDecoration(
                            border: InputBorder.none
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "This Field is required";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    Center(
                      child: SearchLocation(
                        apiKey: "AIzaSyAveoqLGZ5EfEAvGL_JaDvJjCR6KVgufUM",
                        country: 'ph',
                        language: 'ph',
                        icon: Icons.pin_drop_outlined,
                        placeholder: "Set Pick up Location",
                        hasClearButton: true,
                        onSelected: (Place place) async {
                          final geolocation = await place.geolocation;
                          final latlng = LatLng(geolocation!.coordinates.latitude, geolocation.coordinates.longitude);
                          pickupplaceID = place.placeId;
                          pickUpAddressLat = latlng.latitude;
                          pickUpAddressLng = latlng.longitude;
                          pickuplocation = place.description;
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
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: senderController,
                          decoration: const InputDecoration(
                              hintText: "Recipient / Sender",
                              border: InputBorder.none
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "This Field is required";
                            }
                            return null;
                          },
                        ),
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
                        padding: const EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                              hintText: "Contact Number",
                              border: InputBorder.none
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return "This Field is required";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Row(
                        children: [
                          const Text("Size:"),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              controller: size,
                              decoration: const InputDecoration(hintText: "eg: (10 cm)"),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "This Field is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.23 ),
                          const Text("Weigth"),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 70,
                            child: TextFormField(
                              controller: weight,
                              decoration: const InputDecoration(hintText: "eg: (1kg)"),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "This Field is required";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Payment Method"),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                        DropdownButton(
                          hint: const Text('Select One'), // Not necessary for Option 1
                          value: _selectedPayment,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPayment = newValue!;
                            });
                          },
                          items: _payment.map((payment) {
                            return DropdownMenuItem(
                              child: Text(payment),
                              value: payment,
                            );
                          }).toList(),
                        ),
                        ],
                      ),
                    const SizedBox(height: 50),
                    InkWell(
                      onTap: (){
                        if(_formKey.currentState!.validate()){
                          if(pickupplaceID == null){
                            showDialog(
                              context: context,
                              builder: (c){
                                return ErrorDialog(message: "Please fill pick up location",);
                              }
                            );
                          }
                          if(dropoffplaceID == null){
                            showDialog(
                                context: context,
                                builder: (c){
                                  return ErrorDialog(message: "Please fill drop off location",);
                                }
                            );
                          }
                          else {
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiDalaDetails(
                              dropOffAddressLat: dropOffAddressLat,
                              dropOffAddressLng: dropOffAddressLng,
                              dropoffplaceID: dropoffplaceID,
                              pickUpAddressLat: pickUpAddressLat,
                              pickUpAddressLng: pickUpAddressLng,
                              pickupplaceID: pickupplaceID,
                              dropofflocation: dropofflocation,
                              pickuplocation: pickuplocation,
                              notes: notesController.text,
                              payment: _selectedPayment,
                              phone: phoneController.text,
                              sender: senderController.text,
                              size: size.text,
                              weight: weight.text,
                            )));
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
                          child: Text("PROCEED",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.blueAccent.shade400,
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

      ),
    );
  }
}


