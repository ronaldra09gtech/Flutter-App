import 'package:cloud_firestore/cloud_firestore.dart';

class EmarketMenus
{
  String? menuID;
  String? pilamokosellerUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  EmarketMenus({
    this.menuID,
    this.pilamokosellerUID,
    this.menuTitle,
    this.menuInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,

  });

  EmarketMenus.fromJson(Map<String, dynamic> json)
  {
    menuID = json['menuID'];
    pilamokosellerUID = json['pilamokoemarketUID'];
    menuTitle = json['menuTitle'];
    menuInfo = json['menuInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data['pilamokoemarketUID'] = pilamokosellerUID;
    data['menuTitle'] = menuTitle;
    data['menuInfo'] = menuInfo;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}