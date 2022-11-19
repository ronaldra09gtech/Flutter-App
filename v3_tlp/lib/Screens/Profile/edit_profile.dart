import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v3_tlp/Screens/Profile/profile_side_layout.dart';
import '../../global/global.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../../widgets/loading_dialog.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String pilamokotlpImageUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      emailController.text = sharedPreferences!.getString("email")!;
      phoneController.text = sharedPreferences!.getString("phone")!;
      nameController.text = sharedPreferences!.getString("name")!;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) {
            return const LoadingDialog(
              message: "Updating",
            );
          });
      saveWithOutImage();
    }
    else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (c) {
            return const LoadingDialog(
              message: "Updating",
            );
          });
      saveWithImage();
    }
  }

  saveWithImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance
        .ref()
        .child("pilamokotlp")
        .child(fileName);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      pilamokotlpImageUrl = url;
      //save info to firebase
      saveDataToFirestore();
    });
  }

  saveDataToFirestore() async {
    await FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid")!)
        .update({
      "pilamokotlpEmail": emailController.text.trim(),
      "pilamokotlpName": nameController.text.trim(),
      "photoUrl": pilamokotlpImageUrl,
      "phone": phoneController.text.trim(),
    }).whenComplete(() async {
      await sharedPreferences!.setString("photoUrl", pilamokotlpImageUrl);
      await sharedPreferences!.setString("name", nameController.text);
      Fluttertoast.showToast(msg: "Profile Has been Edited");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const SideBarLayoutProfile()));
    });
  }

  saveWithOutImage() async {
    await FirebaseFirestore.instance
        .collection("pilamokotlp")
        .doc(sharedPreferences!.getString("uid")!)
        .update({
      "pilamokotlpEmail": emailController.text.trim(),
      "pilamokotlpName": nameController.text.trim(),
      "photoUrl": pilamokotlpImageUrl,
      "phone": phoneController.text.trim(),
    }).whenComplete(() async {
      await sharedPreferences!.setString("name", nameController.text);
      Fluttertoast.showToast(msg: "Profile Has been Edited");
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const SideBarLayoutProfile()));
    });
  }

    Future<bool?> showWarning(BuildContext context) async =>  showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        content: const Text("Do you want to leave without saving"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Dismiss")
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")
          ),
        ],
      )
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final shouldPop = await showWarning(context);
        return shouldPop ?? true ;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: sharedPreferences!.getString("photoUrl")! == ""
                          ? CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.23,
                        backgroundColor: Colors.white,
                        backgroundImage: imageXFile == null
                            ? null
                            : FileImage(File(imageXFile!.path)),
                        child: imageXFile == null
                            ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey,
                        )
                            : null,
                      )
                          : SizedBox(
                          height: 200,
                          width: 200,
                          child: ClipOval(
                              child: Image.network(sharedPreferences!.getString("photoUrl")!,
                                fit: BoxFit.cover,
                              )
                          )
                      )
                  ),
                  const SizedBox(height: 50),
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: TextFormField(
                      style: const TextStyle(
                          color: Colors.black
                      ),
                      obscureText: false,
                      controller: nameController,
                      decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              color: Colors.black
                          ),
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Input Name";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          child: TextFormField(
                            style: const TextStyle(
                                color: Colors.black
                            ),
                            obscureText: false,
                            controller: phoneController,
                            decoration: InputDecoration(
                                labelStyle: const TextStyle(
                                    color: Colors.black
                                ),
                                labelText: "Phone Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                            ),
                          ),
                        ),
                        Positioned(
                            bottom:  26,
                            right: 18,
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: const BoxDecoration(
                              ),
                              child: Icon(Icons.verified,
                                  color: Colors.blueAccent.shade400),
                            )
                        )
                      ]
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: TextFormField(
                          style: const TextStyle(
                              color: Colors.black
                          ),
                          obscureText: false,
                          controller: emailController,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                  color: Colors.black
                              ),
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                          ),
                        ),
                      ),
                      Positioned(
                          bottom:  26,
                          right: 18,
                          child: Container(
                            height: 17,
                            width: 17,
                            decoration: const BoxDecoration(
                            ),
                            child: Icon(Icons.verified,
                                color: Colors.blueAccent.shade400),
                          )
                      )
                    ],
                  ),

                  const SizedBox(height: 40),
                  InkWell(
                    onTap: (){
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        // formValidation();
                        formValidation();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.blueAccent.shade400
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text("Save Changes",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent.shade400,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
