class Users
{
  String? id;
  String? email;
  String? name;
  String? phone;

  Users({this.phone,this.email,this.id,this.name});

  Users.fromSnapshot(dataSnapshot)
  {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    phone = dataSnapshot.value["phone"];
  }
}