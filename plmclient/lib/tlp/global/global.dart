import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

String email="";
String phone="";
String address="";
String number="";
String zone="";
String date="";
String loadWallet = "";
String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
String currentDateTime = DateFormat("dd MMMM, yyyy - hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(int.parse(currentTime)));
String currentDay = DateFormat("E").format(DateTime.fromMillisecondsSinceEpoch(int.parse(currentTime)));

String googleName="";
String googleId="";
String googlePhotoUrl="";
String googleEmail="";