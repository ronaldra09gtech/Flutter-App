class Eresto
{
  String? pilamokosellerUID;
  String? pilamokosellerName;
  String? pilamokosellerAvatarUrl;
  String? pilamokosellerEmail;

  Eresto({
    this.pilamokosellerUID,
    this.pilamokosellerName,
    this.pilamokosellerAvatarUrl,
    this.pilamokosellerEmail,
  });

  Eresto.fromJson(Map<String, dynamic> json)
  {
    pilamokosellerUID = json["pilamokosellerUID"];
    pilamokosellerName = json["pilamokosellerName"];
    pilamokosellerAvatarUrl = json["pilamokosellerAvatarUrl"];
    pilamokosellerEmail = json["pilamokosellerEmail"];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["pilamokosellerUID"] = pilamokosellerUID;
    data["pilamokosellerName"] = pilamokosellerName;
    data["pilamokosellerAvatarUrl"] = pilamokosellerAvatarUrl;
    data["pilamokosellerEmail"] = pilamokosellerEmail;
    return data;
  }
}

