import 'package:flutter/material.dart';
import 'package:plmclient/queuer/mainScreens/validation/upload_validation.dart';
import '../../global/global.dart';
import '../homescreen/home_screen.dart';

class HasValidation extends StatefulWidget {
  const HasValidation({Key? key}) : super(key: key);

  @override
  State<HasValidation> createState() => _HasValidationState();
}

class _HasValidationState extends State<HasValidation> {
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
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
                  },
                  icon: Icon(Icons.arrow_back)
              );
            },
          ),
        ),
        body: Container(
          child: ListView(
            children: [
              Padding(
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
                        child: validID!.isNotEmpty
                            ? Image.network(validID!,fit: BoxFit.cover,)
                            : Text("Please Upliad Valid ID")
                      )
                    ],
                  ),
                ),
              ),
              const Divider(height: 10, color: Colors.grey, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Expanded(child: Text("License ID", style: TextStyle(fontSize: 24,fontFamily: "Verela"),))
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadValidation(name: "License ID",action: "license",)));
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
                        child: pilamokoqueuerLicenseUrl!.isNotEmpty
                            ? Image.network(pilamokoqueuerLicenseUrl!,fit: BoxFit.cover,)
                            : Text("Please Upload License ID")
                      )
                    ],
                  ),
                ),
              ),
              const Divider(height: 10, color: Colors.grey, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Expanded(child: Text("ORCR", style: TextStyle(fontSize: 24,fontFamily: "Verela"),))
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadValidation(name: "ORCR",action: "orcr",)));
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
                        child: pilamokoqueuerOrcrUrl!.isNotEmpty
                            ? Image.network(pilamokoqueuerOrcrUrl!,fit: BoxFit.cover,)
                            : Text("Please Upload ORCR")
                      )
                    ],
                  ),
                ),
              ),
              const Divider(height: 10, color: Colors.grey, thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Expanded(child: Text("Proof Billing", style: TextStyle(fontSize: 24,fontFamily: "Verela"),))
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (c)=> UploadValidation(name: "Proof Billing",action: "Proof Billing",)));
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
                        child: pilamokoqueuerBillingUrl!.isNotEmpty
                            ? Image.network(pilamokoqueuerBillingUrl!,fit: BoxFit.cover,)
                            : Text("Please Upload Proof Billing"),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
