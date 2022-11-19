import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';



Position? position;
List<Placemark>? placeMarks;
String completeAddress="";
String zone="";
String email="";
String phone="";
String address="";
String phoneNumber="";
String date="";
String loadWallet="";

String pakiDalaPerKMfee="";
String pakiDalaPlugRate="";
String pakiDalaBaseFee="";

String pakiPilaPerHour="";
String pakiPilaPerKM="";
String pakiPilaPlugRate="";
String pakiPilaBasefee="";

double pakiProxyBaseFee =0;
double pakiProxyPlugRate =0;
double pakiProxyfees =0;

String? queuer;
String googleName="";
String googleId="";
String googlePhotoUrl="";
String googleEmail="";

String apiKey="AIzaSyAveoqLGZ5EfEAvGL_JaDvJjCR6KVgufUM";

