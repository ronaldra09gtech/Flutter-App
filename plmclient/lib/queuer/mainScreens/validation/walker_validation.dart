import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/homescreen/walker_homescreen.dart';
import 'package:plmclient/queuer/mainScreens/validation/upload_validation.dart';
import '../../global/global.dart';

class WalkerValidation extends StatefulWidget {
  const WalkerValidation({Key? key}) : super(key: key);

  @override
  State<WalkerValidation> createState() => _WalkerValidationState();
}

class _WalkerValidationState extends State<WalkerValidation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue,
                    Colors.blueAccent,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          centerTitle: true,
          title: Text(
            "My Requirements",
            style: const TextStyle(fontSize: 45.0, letterSpacing: 3, color: Colors.white, fontFamily: "Signatra"),
          ),
          leading: Builder(
            builder: (BuildContext context){
              return IconButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> WalkerHomeScreen()));
                  },
                  icon: Icon(Icons.arrow_back)
              );
            },
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Expanded(child: Text("Valid ID", style: const TextStyle(fontSize: 24,fontFamily: "Verela"),))
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadValidation(name: "Valid ID",action: "validID",)));
                              },
                              child: Icon(Icons.edit),
                            ),
                          )
                      ),
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width-20,
                      height: 250,
                      child: validID != ""
                          ? Image.network(validID!,fit: BoxFit.cover,)
                          : Text("Please Upliad Valid ID")
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

