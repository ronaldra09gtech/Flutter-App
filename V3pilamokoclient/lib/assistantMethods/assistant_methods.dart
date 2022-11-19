import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:v3pilamokoemall/assistantMethods/req_assistant.dart';
import 'package:v3pilamokoemall/assistantMethods/total_amount.dart';
import 'package:v3pilamokoemall/screens/homescreen/homescreen.dart';

import '../global/global.dart';
import 'package:flutter/material.dart';

import 'cart_item_counter.dart';
import 'direction_details.dart';

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

    separateItemIDsList.add(getItemId);
  }

  return separateItemIDsList;
}

separateItemIDs2(List<String> items)
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;

  defaultItemList = items;

  for(i; i<defaultItemList.length; i++)
  {
    String item = defaultItemList[i].toString();
    var pos = item.lastIndexOf(":");
    String getItemId = (pos != -1) ? item.substring(0, pos) : item;


    separateItemIDsList.add(getItemId);
  }


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


    separateItemIDsList.add(getItemId);
  }


  return separateItemIDsList;
}

removeItemfromCart(BuildContext context, String itemid, String qty){
  String combined = "$itemid:$qty";
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.removeWhere((item) => item == combined);

  FirebaseFirestore.instance.collection("pilamokoclient")
      .doc(firebaseAuth.currentUser!.email).update({
    "userCart": tempList,
  }).then((value){
    Fluttertoast.showToast(msg: "Item Remove Successfully.");

    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
    Navigator.push(context, MaterialPageRoute(builder: (c)=> SideBarLayoutHome(page: 3,)));
  });
}

addItemToCard(String? foodItemId, BuildContext context, int itemCounter)
{
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  tempList!.add("${foodItemId!}:$itemCounter");

  FirebaseFirestore.instance.collection("pilamokoclient")
      .doc(firebaseAuth.currentUser!.email).update({
    "userCart": tempList,
  }).then((value){
    Fluttertoast.showToast(msg: "Item Added to cart.");

    sharedPreferences!.setStringList("userCart", tempList);

    //update the badge
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
  });
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



    separateItemQuantitiesList.add(quanNumber);
  }


  return separateItemQuantitiesList;
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



    separateItemQuantitiesList.add(quanNumber.toString());
  }


  return separateItemQuantitiesList;
}

updateCart(context, List<String> checkitems){
  List<String>? tempList = sharedPreferences!.getStringList("userCart");
  List<String> checkoutItems = checkitems;

  print(checkoutItems);
  print(tempList);
  for(var i=0; i< checkoutItems.length; i++){
    tempList!.removeWhere((element) => element == checkoutItems[i]);
  }

  print(tempList);

  FirebaseFirestore.instance.collection("pilamokoclient")
      .doc(firebaseAuth.currentUser!.email).update({
    "userCart": tempList,
  }).then((value){
    sharedPreferences!.setStringList("userCart", tempList!);
    //update the badge
    Provider.of<CartItemCounter>(context, listen: false).displayCartListItemsNumber();
    // Navigator.push(context, MaterialPageRoute(builder: (c)=> SideBarLayoutHome(page: 1,)));
  });
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

  static int calculateFaresEmall(DirectionDetails directionDetails)
  {
    double timeTraveledFare = (directionDetails.distanceValue! / 1000) * double.parse(pakibiliPerKM);
    double Plugrate = timeTraveledFare + double.parse(pakibiliplugrate);
    return Plugrate.truncate();
  }
}
