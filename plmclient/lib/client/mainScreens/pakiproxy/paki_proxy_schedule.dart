import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:location_geocoder/location_geocoder.dart';
import 'package:plmclient/client/assistantMethods/assistant_methods.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/my_booking_screen.dart';
import 'package:plmclient/client/widgets/error_dialog.dart';
import 'package:plmclient/client/widgets/loading_dialog.dart';

import '../../../main.dart';


class PakiProxySchedule extends StatefulWidget {
  String? name, address, schedule;

  PakiProxySchedule({
    this.name,
    this.address,
    this.schedule,
  });
  @override
  State<PakiProxySchedule> createState() => _PakiProxyScheduleState();
}

class _PakiProxyScheduleState extends State<PakiProxySchedule> {

  TextEditingController pickupController = TextEditingController();
  TextEditingController facilities = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController day = TextEditingController();
  TextEditingController time = TextEditingController();

  DateTime? dateee;
  int? hour;

  bool isDriverOnline=false;

  String? valueChoose;
  List listItem = [
    "Cash on Delivery","Topup Load"
  ];

  static const _100_YEARS = Duration(days: 365 * 100);
  @override
  void initState() {
    setState(() {
      facilities.text = widget.name!;
      pickupController.text = widget.address!;
    });
    searchDriverOnline();
  }

  formValidation()async{

    GetData();
    if(time.text.isNotEmpty && day.text.isNotEmpty && notes.text.isNotEmpty)
    {
      if(DateFormat('EEE').format(dateee!).toString() != "Sun" && DateFormat('EEE').format(dateee!).toString() != "Sat"){
        if(hour! < 17){
          const _apiKey = 'AIzaSyAdQzvrdWzzOwTCGrL0joXXVh41UHtcUIw';
          final LocatitonGeocoder geocoder = LocatitonGeocoder(_apiKey);
          final address = await geocoder.findAddressesFromQuery(pickupController.text);
          print(address.first.coordinates.latitude);
          print(address.first.coordinates.longitude);

          if(isDriverOnline)
          {
            if(valueChoose == "Topup Load")
            {

              if(double.parse(loadWallet) > AssistantMethods.calculateFaresPakiProxy())
              {
                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return LoadingDialog(
                        message: "Creating Booking",
                      );
                    }
                );
                double newloadWallet = double.parse(loadWallet) - AssistantMethods.calculateFaresPakiProxy();
                String orderId = DateTime.now().millisecondsSinceEpoch.toString();
                await FirebaseFirestore.instance.collection("booking")
                    .doc(orderId).set({
                  "pickupaddress": pickupController.text,
                  "pickupaddressLat": address.first.coordinates.latitude,
                  "pickupaddressLng": address.first.coordinates.longitude,
                  "notes": notes.text,
                  "phoneNum": phone,
                  "price": AssistantMethods.calculateFaresPakiProxy(),
                  "paymentMethods": valueChoose,
                  "orderTime": orderId,
                  "serviceType": "paki-proxy",
                  "zone": zone,
                  "isSuccess": true,
                  "clientUID": sharedPreferences!.getString("email"),
                  "riderUID": "",
                  "status": "normal",
                  "bookID": orderId,
                }).then((value){
                  FirebaseFirestore.instance
                      .collection("pilamokoclient")
                      .doc(sharedPreferences!.getString("email"))
                      .update({
                    "loadWallet": newloadWallet
                  });
                }).whenComplete((){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingScreen()));
                  Fluttertoast.showToast(msg: "Congratulations, booking has been placed successfully.");
                });
              }
              else
              {

                showDialog(
                    context: context,
                    builder: (c)
                    {
                      return ErrorDialog(
                        message: "Not enough load!",
                      );
                    }
                );
              }
            }
            else if(valueChoose == "Cash on Delivery")
            {
              showDialog(
                  context: context,
                  builder: (c)
                  {
                    return LoadingDialog(
                      message: "Creating Booking",
                    );
                  }
              );
              String orderId = DateTime.now().millisecondsSinceEpoch.toString();
              await FirebaseFirestore.instance.collection("booking")
                  .doc(orderId).set({
                "pickupaddress": pickupController.text,
                "pickupaddressLat": address.first.coordinates.latitude,
                "pickupaddressLng": address.first.coordinates.longitude,
                "notes": notes.text,
                "phoneNum": phone,
                "price": AssistantMethods.calculateFaresPakiProxy(),
                "paymentMethods": valueChoose,
                "orderTime": orderId,
                "serviceType": "paki-proxy",
                "zone": zone,
                "isSuccess": true,
                "clientUID": sharedPreferences!.getString("email"),
                "riderUID": "",
                "status": "normal",
                "bookID": orderId,
              }).whenComplete((){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingScreen()));
                Fluttertoast.showToast(msg: "Congratulations, booking has been placed successfully.");
              });
            }
            else
            {
              showDialog(
                  context: context,
                  builder: (c)
                  {
                    return ErrorDialog(
                      message: "Please provide payment method.",
                    );
                  }
              );
            }
          }
          else
          {
            showDialog(
                context: context,
                builder: (c)
                {
                  return ErrorDialog(
                    message: "There's no Available Queuer.",
                  );
                }
            );
          }
        }
        else {
          showDialog(
              context: context,
              builder: (c)
              {
                return ErrorDialog(
                  message: "Time should not be past 5 PM.",
                );
              }
          );
        }
      }
      else{
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please Select from Monday to Friday.",
              );
            }
        );
      }
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please Set Schedule.",
            );
          }
      );
    }
  }

  searchDriverOnline()
  {
    FirebaseFirestore.instance
        .collection("pilamokoQueuerAvailableDrivers").where("status", isEqualTo: "online")
        .get()
        .then((snapshot){
      if(snapshot.docs.isNotEmpty)
      {
        isDriverOnline=true;
      }
      else
      {
        isDriverOnline=false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
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
          ),
          title: const Text(
            "PILAMOKO",
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
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
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                "Paki-Proxy",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      enabled: false,
                      controller: facilities,
                      obscureText: false,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.document_scanner_outlined,
                          color: Colors.blue,
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        hintText: "Facilities",
                        labelText: "Facilities",
                          labelStyle: TextStyle(color: Colors.black)
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      enabled: false,
                      maxLines: 3,
                      controller: pickupController,
                      obscureText: false,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.add_location_alt_outlined,
                          color: Colors.blue,
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        hintText: "Pick-up Location",
                          labelText: "Pick-up Location",
                        labelStyle: TextStyle(color: Colors.black)

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("Please Select from " + widget.schedule!),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      onTap: ()async{
                        final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(_100_YEARS)
                        );
                        final finaldate = DateFormat('EEE d MMM yyyy').format(date!);
                        setState(() {
                          day.text = finaldate.toString();
                          dateee = date;
                        });
                      },
                      enabled: true,
                      controller: day,
                      obscureText: false,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),
                        focusColor: Theme.of(context).primaryColor,
                          labelText: "Day",
                          labelStyle: TextStyle(color: Colors.black)

                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      onTap: ()async{
                        final timee = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                        );
                        print(timee!.minute);
                        setState(() {
                          time.text = timee.hour.toString() + ":" + timee.minute.toString();
                          hour = timee.hour;
                        });
                      },
                      enabled: true,
                      controller: time,
                      obscureText: false,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: Colors.blue,
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          labelText: "Time",
                          labelStyle: TextStyle(color: Colors.black)

                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: TextFormField(
                      enabled: true,
                      controller: notes,
                      obscureText: false,
                      maxLines: 5,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.document_scanner_outlined,
                            color: Colors.blue,
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Notes",
                          labelText: "Notes",
                          labelStyle: TextStyle(color: Colors.black)
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Payment Method"),
                        ),
                        Expanded(
                          child: DropdownButton(
                            value: valueChoose,
                            onChanged: (newValue){
                              setState(() {
                                valueChoose = newValue as String?;
                              });
                              print(valueChoose);
                            },
                            items: listItem.map((valueItem){
                              return DropdownMenuItem(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    ),
                    onPressed: () async
                    {

                      formValidation();
                    },
                  ),
                ],
              )
            ],
          )
        ),
      ),
    );

  }



}
