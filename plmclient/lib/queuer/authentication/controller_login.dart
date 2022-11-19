import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plmclient/queuer/authentication/user_details_model.dart';

class ControllerLogin with ChangeNotifier{
  var googleSignInNow = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  UserDetailsModel? userDetailsModel;

  allowUserToLogin() async
  {
    this.googleSignInAccount = await googleSignInNow.signIn();

    this.userDetailsModel = new UserDetailsModel(
      displayName: this.googleSignInAccount!.displayName,
      email: this.googleSignInAccount!.email,
      photoUrl: this.googleSignInAccount!.photoUrl,
    );

    notifyListeners();
  }
}