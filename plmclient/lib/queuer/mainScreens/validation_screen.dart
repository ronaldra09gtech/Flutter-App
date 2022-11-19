import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plmclient/queuer/widgets/simple_app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../../main.dart';
import '../global/global.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({Key? key}) : super(key: key);

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {

  XFile? imageXFile;
  XFile? OrcrUrl;
  XFile? BillingUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> _getOrcrUrl() async {
    OrcrUrl = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      OrcrUrl;
    });
  }

  Future<void> _getBillingUrl() async {
    BillingUrl = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      BillingUrl;
    });
  }



  Future<void> formValidation() async {
    if (imageXFile == null && OrcrUrl == null && BillingUrl == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image.",
            );
          });
    }
    else
    {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingDialog(
              message: "Uploading Plase Wait...",
            );
          });
      uploadlicense();
    }
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
    uploadOrcrUrl();
  }

  uploadOrcrUrl() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoqueuer")
        .child(fileName);
    fStorage.UploadTask uploadTask =
    reference.putFile(File(OrcrUrl!.path));
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
    uploadBillingUrl();
  }

  uploadBillingUrl() async
  {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokoqueuer")
        .child(fileName);
    fStorage.UploadTask uploadTask =
    reference.putFile(File(BillingUrl!.path));
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
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (c)=> ValidationScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Requirements",),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Expanded(child: Text("License ID", style: const TextStyle(fontSize: 24,fontFamily: "Verela"),))
                ),
                InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: imageXFile == "" && pilamokoqueuerLicenseUrl ==""
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
                        child: imageXFile != null
                            ? Image.file(File(imageXFile!.path),fit: BoxFit.cover,)
                            : Container(
                            width: MediaQuery.of(context).size.width-20,
                            height: 250,
                            child: Image.network(pilamokoqueuerLicenseUrl!,fit: BoxFit.cover,)
                        )
                    )
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Expanded(child: Text("ORCR", style: const TextStyle(fontSize: 24,fontFamily: "Verela"),))
                ),
                InkWell(
                    onTap: () {
                      _getOrcrUrl();
                    },
                    child: OrcrUrl == "" && pilamokoqueuerOrcrUrl ==""
                        ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width-20,
                        height: 200,
                        child: Image.asset("images/upload2.png"),
                      ),
                    )
                        : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: OrcrUrl != null
                            ? Image.file(File(OrcrUrl!.path),fit: BoxFit.cover,)
                            : Container(
                          width: MediaQuery.of(context).size.width-20,
                          height: 250,
                          child: Image.network(pilamokoqueuerOrcrUrl!,fit: BoxFit.cover,)
                        )
                    )
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Expanded(child: Text("Proof Billing", style: TextStyle(fontSize: 24,fontFamily: "Verela"),))
                ),
                InkWell(
                    onTap: () {
                      _getBillingUrl();
                    },
                    child: BillingUrl == "" && pilamokoqueuerBillingUrl ==""
                        ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width-20,
                        height: 200,
                        child: Image.asset("images/upload3.png"),
                      ),
                    )
                        : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: BillingUrl != null
                            ? Image.file(File(BillingUrl!.path),fit: BoxFit.cover,)
                            : Container(
                            width: MediaQuery.of(context).size.width-20,
                            height: 250,
                            child: Image.network(pilamokoqueuerBillingUrl!,fit: BoxFit.cover,)
                        )
                    )
                ),
              ],
            ),
          ),
          pilamokoqueuerBillingUrl =="" && pilamokoqueuerLicenseUrl== "" && pilamokoqueuerOrcrUrl==""
              ? Padding(
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
                formValidation();
              },
            ),
          )
              :
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: ElevatedButton(
              child: const Text(
                "Edit",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: ()
              {
                formValidation();
              },
            ),
          )
        ],
      ),
    );
  }
}
