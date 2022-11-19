import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plmclient/queuer/widgets/simple_app_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import '../../../main.dart';
import '../../global/global.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading_dialog.dart';

class WalkerBikerValidationScreen extends StatefulWidget {
  const WalkerBikerValidationScreen({Key? key}) : super(key: key);

  @override
  State<WalkerBikerValidationScreen> createState() => _WalkerBikerValidationScreenState();
}

class _WalkerBikerValidationScreenState extends State<WalkerBikerValidationScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }



  Future<void> formValidation() async {
    if (imageXFile == null) {
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
      "validID": pilamokoqueuerLicenseUrl,
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerBikerValidationScreen()));
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
                    child: Expanded(child: Text("Valid ID", style: const TextStyle(fontSize: 24,fontFamily: "Verela"),))
                ),
                InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: imageXFile != null && pilamokoqueuerLicenseUrl!.isEmpty
                        ? Image.file(File(imageXFile!.path),fit: BoxFit.cover,)
                        : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: imageXFile == null && pilamokoqueuerLicenseUrl !=""
                            ? Image.network(pilamokoqueuerLicenseUrl!,)
                            : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width-20,
                            height: 200,
                            child: Image.asset("images/upload.png"),
                          ),
                        )
                    )
                ),
              ],
            ),
          ),
          validID!.isEmpty
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
