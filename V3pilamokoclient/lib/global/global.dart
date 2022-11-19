import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
Position? position;
List<Placemark>? placeMarks;
String apiKey="AIzaSyAveoqLGZ5EfEAvGL_JaDvJjCR6KVgufUM";


String completeAddress="";
String zone="";
String address="";
String queuer="";
double loadWallet=0;

String pakiDalaPerKMfee="";
String pakiDalaPlugRate="";
String pakiDalaBaseFee="";

String pakibiliPerKM="";
String pakibiliplugrate="";