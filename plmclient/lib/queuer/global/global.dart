import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

Position? position;
List<Placemark>? placeMarks;
String completeAddress="";

String perParcelDeliveryAmount="";
String previousEarnings=""; //for seller
String previousRiderEarnings=""; //rider
String zone=""; //rider
String email="";
String load="";
String? tlp;
String phone="";
String address="";
String number="";

String perhalfhr = "";
String basefee = "";
String pakiPilafees="";
String pakiDalafees="";

User? firebaseUser;

StreamSubscription<Position>? homeTabPageStreamSubscription;

DocumentReference? usersRef =  FirebaseFirestore.instance
    .collection("pilamokoQueuerAvailableDrivers")
    .doc(sharedPreferences!.getString("email"));

String queuerStatus = "Offline Now - Go Online";
Color queuerStatusColor= Colors.black;
bool isQueuerAvailable = false;

String? pilamokoqueuerLicenseUrl;
String? pilamokoqueuerOrcrUrl;
String? pilamokoqueuerBillingUrl;
String? validID;

