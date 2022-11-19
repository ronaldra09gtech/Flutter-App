

class UserDetailsModel{
  String? displayName;
  String? email;
  String? photoUrl;

  UserDetailsModel({this.displayName, this.email, this.photoUrl});

  UserDetailsModel.fromJson(Map<String, dynamic> json)
  {
    displayName = json["displayName"];
    photoUrl = json["photoUrl"];
    email = json["email"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> mapData = new Map<String, dynamic>();

    mapData["displayName"] = this.displayName;
    mapData["photoUrl"] = this.photoUrl;
    mapData["email"] = this.email;

    return mapData;
  }
}