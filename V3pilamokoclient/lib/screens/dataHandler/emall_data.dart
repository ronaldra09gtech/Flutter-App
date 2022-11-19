import 'package:cloud_firestore/cloud_firestore.dart';

class Emalldata
{
  String? pilamokosellerUID;
  String? pilamokosellerName;
  String? pilamokosellerAvatarUrl;
  String? pilamokosellerEmail;
  String? shopName;

  Emalldata({
    this.pilamokosellerUID,
    this.pilamokosellerName,
    this.pilamokosellerAvatarUrl,
    this.pilamokosellerEmail,
    this.shopName,
  });
}

class EmallMenus
{
  String? pilamokosellerUID;
  String? menuTitle;
  String? menuID;
  String? shopName;

  EmallMenus({
    this.pilamokosellerUID,
    this.menuID,
    this.menuTitle,
    this.shopName,

  });

}

class EmallItems
{
  String? menuID;
  String? pilamokosellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  String? shopName;
  int? price;

  EmallItems({
    this.menuID,
    this.pilamokosellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    this.shopName,
  });

  EmallItems.fromJson(Map<String, dynamic> json)
  {
    menuID = json['menuID'];
    pilamokosellerUID = json['pilamokoemallUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    shopName = json['shopName'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuID'] = menuID;
    data['pilamokoemallUID'] = pilamokosellerUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['price'] = price;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['longDescription'] = longDescription;
    data['status'] = status;

    return data;
  }
}