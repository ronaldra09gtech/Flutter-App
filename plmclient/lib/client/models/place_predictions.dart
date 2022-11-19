class PlacePrediction
{
  String? secondary_text;
  String? main_text;
  String? place_id;

  PlacePrediction({this.main_text,this.place_id,this.secondary_text});

  PlacePrediction.fromJson(Map<String,dynamic> json)
  {
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }
}

class DropOffPlacePrediction
{
  String? secondary_text;
  String? main_text;
  String? place_id;

  DropOffPlacePrediction({this.main_text,this.place_id,this.secondary_text});

  DropOffPlacePrediction.fromJson(Map<String,dynamic> json)
  {
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }
}