import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:v3pilamokoemall/screens/add_to_cart_screen/checkoutpage.dart';
import 'package:v3pilamokoemall/screens/profilescreen/my_addressess.dart';

import '../../global/global.dart';
import '../../widgets/loading_dialog.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController zoneController = TextEditingController();

  getCurrentLocation() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          return const LoadingDialog(message: "",);
        }
    );
    // LocationPermission permission;permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
    '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
    zoneController.text = '${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea} ${pMark.administrativeArea}';
    Navigator.pop(context);
  }

  formValidation()async{
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (c) {
          return const LoadingDialog(message: "",);
        }
    );
    await FirebaseFirestore.instance.collection("pilamokoclient")
        .doc(sharedPreferences!.getString("email")!)
        .collection("myDeliveryAddresses").doc()
        .set({
      "name": nameController.text,
      "phone": phoneController.text,
      "address": locationController.text,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "status": 'Not in use',
    }).whenComplete((){
      Navigator.of(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> MyAddressess()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = sharedPreferences!.getString("name")!;
    phoneController.text = sharedPreferences!.getString("phone")!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70.withOpacity(0.9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Contact",style: TextStyle(fontWeight: FontWeight.w300),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                enableSuggestions: true,
                controller: nameController,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true ,
                    fillColor: Colors.white,
                    focusColor: Colors.black,
                  label: Text("Full Name"),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "This field is required";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: phoneController,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true ,
                  fillColor: Colors.white,
                  focusColor: Colors.black,
                  label: Text("Contact"),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "This field is required";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Address",style: TextStyle(fontWeight: FontWeight.w300),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: locationController,
                maxLines: 2,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true ,
                  fillColor: Colors.white,
                  focusColor: Colors.black,
                  label: Text("Address"),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "This field is required";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text("Note: We recommend to use the button below to get your accurate ADDRESS and ZONE base on your device, To help the rider locate you"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  getCurrentLocation();
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueAccent.shade400
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("Get My Current Location",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueAccent.shade400,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    formValidation();
                    // formValidation();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.blueAccent.shade400
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text("Submit",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.blueAccent.shade400,
                        fontWeight: FontWeight.bold
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
