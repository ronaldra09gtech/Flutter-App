import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plmclient/client/assistantMethods/app_data.dart';
import 'package:plmclient/client/assistantMethods/req_assistant.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/mainScreens/home_screen.dart';
import 'package:plmclient/client/models/address.dart';
import 'package:plmclient/client/widgets/customTextField.dart';
import 'package:plmclient/client/widgets/error_dialog.dart';
import 'package:plmclient/client/widgets/loading_dialog.dart';
import 'package:plmclient/client/models/place_predictions.dart';
import 'package:plmclient/client/mainScreens/pakipila/paki_pila_details.dart';
import 'package:provider/provider.dart';

TextEditingController pickupController = TextEditingController();
TextEditingController dropoffController = TextEditingController();
List<PlacePrediction> placePredictionList= [];
List<DropOffPlacePrediction> dropOffPlacePredictionList = [];
double? pickUpAddressLat;
double? pickUpAddressLng;
double? dropOffAddressLat;
double? dropOffAddressLng;
String? dropoffplaceID;
String? pickupplaceID;

class PakiPilaScreen extends StatefulWidget {
  @override
  _PakiPilaScreenState createState() => _PakiPilaScreenState();
}

class _PakiPilaScreenState extends State<PakiPilaScreen> {
  Position? position;
  String completeAddress = "";

  String orderId = DateTime.now().millisecondsSinceEpoch.toString();


  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];
    setState(() {
      completeAddress =
      '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    });
  }

  Future<void> formValidation() async {
    if (pickupController.text.isNotEmpty &&
        dropoffController.text.isNotEmpty &&
        notesController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      showDialog(context: context, builder: (c){
        return LoadingDialog(message: "Please Wait",);
      });
      print(pickupplaceID);
      print(dropoffplaceID);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiPilaBookingDetails(
        pickuplocation: pickupController.text.trim(),
        dropofflocation: dropoffController.text.trim(),
        dropoffplaceID: pickupplaceID,
        pickupplaceID: dropoffplaceID,
        notes: notesController.text.trim(),
        phone: phoneController.text.trim(),
      )));
    }
    else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please Fill all Fields",
            );
          });
    }
  }

  String? value;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController notesController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setState(() {
      phoneController.text = phoneNumber;
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
          leading: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
              },
              child: Icon(Icons.arrow_back)
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  "Paki-Pila Bayad",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(10),
                      child: TextFormField(
                        onChanged: (val){
                          findPlace(val);
                        },
                        enabled: true,
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
                        ),
                      ),
                    ),
                    (placePredictionList.isNotEmpty)
                        ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                      child: ListView.separated(
                        padding: EdgeInsets.all(8),
                        itemBuilder: (c, index)
                        {
                          return PredictionTile(placePrediction: placePredictionList[index],);
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Colors.black, thickness: 1,),
                        itemCount: placePredictionList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    )
                        : Container(),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(10),
                      child: TextFormField(
                        onChanged: (val){
                          findDropOffPlace(val);
                        },
                        enabled: true,
                        controller: dropoffController,
                        obscureText: false,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.add_location_alt_outlined,
                            color: Colors.blue,
                          ),
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Drop-off Location",
                        ),
                      ),
                    ),
                    (dropOffPlacePredictionList.isNotEmpty)
                        ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                      child: ListView.separated(
                        padding: EdgeInsets.all(8),
                        itemBuilder: (c, index)
                        {
                          return DropOffPredictionTile(dropOffPlacePrediction: dropOffPlacePredictionList[index],);
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Colors.black, thickness: 1,),
                        itemCount: dropOffPlacePredictionList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                      ),
                    )
                        : Container(),
                    CustomTextField(
                      data: Icons.note_add,
                      controller: notesController,
                      hintText: "What Item? ",
                      isObsecre: false,
                    ),
                    CustomTextField(
                      data: Icons.phone,
                      controller: phoneController,
                      hintText: "Phone Number",
                      isObsecre: false,
                    ),
                    SizedBox(
                      height: 15,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text("There will be additional ₱${pakiPilaPerHour} charge per hour"),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      onPressed: () {
                        formValidation();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetails()));

                      },
                    ),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&key=$apiKey&sessiontoken=1234567890&components=country:ph";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed"){
        return;
      }
      if(res["status"]=="OK")
      {
        var predictions = res["predictions"];
        var placesList = (predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }

  void findDropOffPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&key=$apiKey&sessiontoken=1234567890&components=country:ph";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed"){
        return;
      }
      if(res["status"]=="OK")
      {
        var predictions = res["predictions"];
        var dropOffplacesList = (predictions as List).map((e) => DropOffPlacePrediction.fromJson(e)).toList();
        setState(() {
          dropOffPlacePredictionList = dropOffplacesList;
        });
      }
    }
  }

}

class PredictionTile extends StatefulWidget {

  final PlacePrediction? placePrediction;

  PredictionTile({Key? key, this.placePrediction}) : super(key: key);

  @override
  State<PredictionTile> createState() => _PredictionTileState();
}

class _PredictionTileState extends State<PredictionTile> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
        getPlaceAddressDetails(widget.placePrediction!.place_id.toString(), context);

      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.placePrediction!.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 2,),
                      Text(widget.placePrediction!.secondary_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12,color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async
  {
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=$apiKey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if(res == "failed"){
      return;
    }

    if(res["status"]=="OK")
    {
      Addressv2 address = Addressv2();
      address.placename = res["result"]["name"];
      address.placeID = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(address);
      print("this is location");
      print(address.placename);
      pickupController.text = widget.placePrediction!.main_text.toString() +" "+ widget.placePrediction!.secondary_text.toString();
      setState(() {
        pickupplaceID =res["result"]["place_id"];
        pickUpAddressLat = res["result"]["geometry"]["location"]["lat"];
        pickUpAddressLng = res["result"]["geometry"]["location"]["lng"];
        placePredictionList.clear();

      });
      Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiPilaScreen()));
    }
  }
}

class DropOffPredictionTile extends StatefulWidget {
  final DropOffPlacePrediction? dropOffPlacePrediction;
  const DropOffPredictionTile({Key? key, this.dropOffPlacePrediction}) : super(key: key);

  @override
  _DropOffPredictionTileState createState() => _DropOffPredictionTileState();
}

class _DropOffPredictionTileState extends State<DropOffPredictionTile> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
        getPlaceAddressDetails(widget.dropOffPlacePrediction!.place_id.toString(), context);

      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white70,
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dropOffPlacePrediction!.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 2,),
                      Text(widget.dropOffPlacePrediction!.secondary_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12,color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async
  {
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=$apiKey";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if(res == "failed"){
      return;
    }

    if(res["status"]=="OK")
    {
      Addressv2 address = Addressv2();
      address.placename = res["result"]["name"];
      address.placeID = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false).updateDropOffLocationAddress(address);
      print("this is location");
      print(address.placename);
      dropoffController.text = widget.dropOffPlacePrediction!.main_text.toString() +" "+ widget.dropOffPlacePrediction!.secondary_text.toString();
      setState(() {
        dropoffplaceID = res["result"]["place_id"];
        dropOffAddressLat = res["result"]["geometry"]["location"]["lat"];
        dropOffAddressLng = res["result"]["geometry"]["location"]["lng"];
        placePredictionList.clear();
        dropOffPlacePredictionList.clear();
      });
      Navigator.push(context, MaterialPageRoute(builder: (c)=> PakiPilaScreen()));
    }
  }
}


