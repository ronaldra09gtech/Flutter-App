import 'package:cloud_firestore/cloud_firestore.dart';

class ErestoMenus
{
  String? menuID;
  String? pilamokosellerUID;
  String? menuTitle;
  String? menuInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? status;

  ErestoMenus({
    this.menuID,
    this.pilamokosellerUID,
    this.menuTitle,
    this.menuInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.status,

  });

  ErestoMenus.fromJson(Map<String, dynamic> json)
  {
    menuID = json['menuID'];
    pilamokosellerUID = json['pilamokosellerUID'];
    menuTitle = json['menuTitle'];
    menuInfo = json['menuInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data['pilamokosellerUID'] = pilamokosellerUID;
    data['menuTitle'] = menuTitle;
    data['menuInfo'] = menuInfo;
    data['publishedDate'] = publishedDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['status'] = status;

    return data;
  }
}