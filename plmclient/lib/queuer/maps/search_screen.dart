import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plmclient/queuer/Datahandler/appData.dart';
import 'package:plmclient/queuer/assistantMethods/request_assistant.dart';
import 'package:plmclient/queuer/maps/mainscreen.dart';
import 'package:plmclient/queuer/models/address.dart';
import 'package:plmclient/queuer/models/place_predictions.dart';
import 'package:plmclient/queuer/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpController = TextEditingController();
  TextEditingController dropOffController = TextEditingController();
  List<PlacePredictions> placePredictionList= [];


  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation!.placename.toString();
    pickUpController.text = placeAddress;
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  )
                ]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> MapScreen()));
                          },
                          child: Icon(Icons.arrow_back)
                      ),
                      Center(
                        child: Text("Set Drop off", style: TextStyle(fontSize: 18,fontFamily: "Brand"),),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16, width: 16),
                      SizedBox(height: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(

                              controller: pickUpController,
                              decoration: InputDecoration(
                                  hintText: "PickUp Location",
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11, top: 0.9, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16, width: 16),
                      SizedBox(height: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              controller: dropOffController,
                              decoration: InputDecoration(
                                  hintText: "Where to?",
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11, top: 0.9, bottom: 8)
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                  ,
                ],
              ),
            ),
          ),
          (placePredictionList.length > 0)
              ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
            child: ListView.separated(
              padding: EdgeInsets.all(8),
              itemBuilder: (c, index)
              {
                return PredictionTile(placePredictions: placePredictionList[index],);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(height: 1, color: Colors.black, thickness: 1,),
              itemCount: placePredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
              : Container()
        ],
      ),
    );
  }
  void findPlace(String placeName) async
  {
    if(placeName.length > 1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${placeName}&key=AIzaSyAdQzvrdWzzOwTCGrL0joXXVh41UHtcUIw&sessiontoken=1234567890&components=country:ph";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed"){
        return;
      }
      if(res["status"]=="OK")
      {
        var predictions = res["predictions"];
        var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {

  final PlacePredictions? placePredictions;

  PredictionTile({Key? key, this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: (){
        getPlaceAddressDetails(placePredictions!.place_id.toString(), context);
      },
      child: Container(
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
                        placePredictions!.main_text.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 2,),
                      Text(placePredictions!.secondary_text.toString(),
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
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Setting Dropoff, Please wait...",
          );
        });
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&key=AIzaSyAdQzvrdWzzOwTCGrL0joXXVh41UHtcUIw";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    Navigator.pop(context);
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

      Navigator.pop(context, "obtainDirections");
    }
  }
}
