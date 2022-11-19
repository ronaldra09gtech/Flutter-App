import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plmclient/queuer/mainScreens/validation/has_validation.dart';
import 'package:plmclient/queuer/widgets/error_dialog.dart';
import 'package:plmclient/queuer/widgets/loading_dialog.dart';
import 'package:plmclient/queuer/widgets/simple_app_bar.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../../../main.dart';
import '../../global/global.dart';

class UploadValidation extends StatefulWidget {

  String? name, action;

  UploadValidation({this.name,this.action});

  @override
  State<UploadValidation> createState() => _UploadValidationState();
}

class _UploadValidationState extends State<UploadValidation> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }
  formValidation(String action){
    if(imageXFile != null){
      showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Uploading Plase Wait...",
            );
          });
      if(action =="validID"){
        uploadID();
      }
      else if(action =="license"){
        uploadlicense();
      }
      else if(action =="orcr"){
        uploadOrcrUrl();
      }
      else{
        uploadBillingUrl();
      }
    }
    else{
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image.",
            );
          });
    }
  }

  uploadID() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoqueuer")
        .child(fileName);
    fStorage.UploadTask uploadTask =
    reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot =
    await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      setState(() {
        validID = url;
      });
      //save info to firebase
      savetofirestoreIDUrl();
    });
  }
  savetofirestoreIDUrl()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email")!)
        .update({
      "validID": validID,
    });
    getBack();
  }

  uploadlicense() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoqueuer")
        .child(fileName);
    fStorage.UploadTask uploadTask =
    reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot =
    await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      setState(() {
        pilamokoqueuerLicenseUrl = url;
      });
      //save info to firebase
      savetofirestoreLicenseUrl();
    });
  }

  savetofirestoreLicenseUrl()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email")!)
        .update({
      "pilamokoqueuerLicenseUrl": pilamokoqueuerLicenseUrl,
    });
    getBack();
  }

  uploadOrcrUrl() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoqueuer")
        .child(fileName);
    fStorage.UploadTask uploadTask =
    reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot =
    await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      setState(() {
        pilamokoqueuerOrcrUrl = url;
      });
      //save info to firebase
      savetofirestoreOrcrUrl();
    });
  }

  savetofirestoreOrcrUrl()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email")!)
        .update({
      "pilamokoqueuerOrcrUrl": pilamokoqueuerOrcrUrl,
    });
    getBack();
  }

  uploadBillingUrl() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoqueuer")
        .child(fileName);
    fStorage.UploadTask uploadTask =
    reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot =
    await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      setState(() {
        pilamokoqueuerBillingUrl = url;
      });
      //save info to firebase
      savetofirestoreBillingUrl();
    });
  }

  savetofirestoreBillingUrl()
  {
    FirebaseFirestore.instance
        .collection("pilamokoqueuer")
        .doc(sharedPreferences!.getString("email")!)
        .update({
      "pilamokoqueuerBillingUrl": pilamokoqueuerBillingUrl,
    });
    getBack();
  }

  getBack(){
    imageXFile = null;
    Navigator.pop(context);
    if(sharedPreferences!.getString("queuerType")!.toString() == "Walking Queuer"){
    }
    else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Bike / Bike"){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> HasValidation()));
    }
    else if(sharedPreferences!.getString("queuerType")!.toString() == "Queuer with Motorcycle" || sharedPreferences!.getString("queuerType")!.toString() == "Queuer with 4 Wheels"){
      Navigator.push(context, MaterialPageRoute(builder: (c)=> HasValidation()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: widget.name),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Expanded(child: Text(widget.name!, style: const TextStyle(fontSize: 24,fontFamily: "Verela"),))
              ),
              InkWell(
                  onTap: () {
                    _getImage();
                  },
                  child: imageXFile == null
                      ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width-20,
                      height: 200,
                      child: Image.asset("images/upload.png"),
                    ),
                  )
                      : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.file(File(imageXFile!.path),fit: BoxFit.cover,)
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton(
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  ),
                  onPressed: ()
                  {
                    formValidation(widget.action!);
                  },
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
