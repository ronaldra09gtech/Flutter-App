import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plmclient/client/assistantMethods/cart_item_counter.dart';
import 'package:plmclient/client/assistantMethods/req_assistant.dart';
import 'package:plmclient/client/global/global.dart';
import 'package:plmclient/client/models/address.dart';
import 'package:plmclient/client/models/direction_details.dart';
import 'package:provider/provider.dart';

import '../../main.dart';


separateOrderItemIDs(orderIDs)
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = List<String>.from(orderIDs) ;

  for(i; i<defaultItemList.length; i++)
  {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Item List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

separateItemIDs()
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++)
  {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;

    print("\nThis is itemID now = " + getItemId);

    separateItemIDsList.add(getItemId);
  }

  print("\nThis is Item List now = ");
  print(separateItemIDsList);

  return separateItemIDsList;
}

addItemToCard(String? foodItemId, BuildContext context, int itemCounter)
{
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add(foodItemId! + ":$itemCounter");

  FirebaseFirestore.instance.collection("pilamokoclient")
      .doc(firebaseAuth.currentUser!.email).update({
    "userCart": tempList,
  }).then((value){
    Fluttertoast.showToast(msg: "Item Added Successfully.");

    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });
}

Future GetData() async
{
  FirebaseFirestore.instance
      .collection("pilamokoclient")
      .doc(sharedPreferences!.getString("email"))
      .get()
      .then((snap){
      loadWallet = snap.data()!['loadWallet'].toString();
  });
  return loadWallet;
}

separateOrderItemQuantities(orderIDs)
{
  List<String> separateItemQuantitiesList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList = List<String>.from(orderIDs) ;

  for(i; i<defaultItemList.length; i++)
  {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());


    print("\nThis is quantity number = " + quanNumber.toString());

    separateItemQuantitiesList.add(quanNumber.toString());
  }

  print("\nThis is item quantity list now = ");
  print(separateItemQuantitiesList);

  return separateItemQuantitiesList;
}

separateItemQuantities()
{
  List<int> separateItemQuantitiesList=[];
  List<String> defaultItemList=[];
  int i=1;

  defaultItemList = sharedPreferences!.getStringList("userCart")!;

  for(i; i<defaultItemList.length; i++)
  {
    String item = defaultItemList[i].toString();

    List<String> listItemCharacters = item.split(":").toList();

    var quanNumber = int.parse(listItemCharacters[1].toString());


    print("\nThis is quantity number = " + quanNumber.toString());

    separateItemQuantitiesList.add(quanNumber);
  }

  print("\nThis is item quantity list now = ");
  print(separateItemQuantitiesList);

  return separateItemQuantitiesList;
}

clearCartNow(context)
{
  sharedPreferences!.setStringList("userCart", ['garbageValue']);
  List<String>? emptyList = sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance
      .collection("pilamokoclient")
      .doc(firebaseAuth.currentUser!.email)
      .update({"userCart": emptyList}).then((value)
  {
    sharedPreferences!.setStringList("userCart", emptyList!);
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });

}
class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";
    var response = await RequestAssistant.getRequest(url);

    if(response != "failed")
    {
      placeAddress = response["results"][0]["formatted_address"];
      Addressv2 userPickupAddress = new Addressv2();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placename = placeAddress;

    }
    return placeAddress;
  }

  static Future<DirectionDetails?> obtainDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$apiKey";
    var response = await RequestAssistant.getRequest(directionUrl);

    if(response == "failed")
    {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = response["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText = response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = response["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText = response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = response["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails)
  {
    double timeTraveledFare = (directionDetails.distanceValue! / 1000) * double.parse(pakiDalaPerKMfee);
    double Plugrate = timeTraveledFare + double.parse(pakiDalaPlugRate);
    return Plugrate.truncate();
  }

  static int calculateFaresPerhr(DirectionDetails directionDetails)
  {
    double baseFee =  double.parse(pakiPilaBasefee);
    return baseFee.truncate();
  }

  static int calculateFaresPakiProxy()
  {
    double baseFee = pakiProxyBaseFee;
    return baseFee.truncate();
  }
}
