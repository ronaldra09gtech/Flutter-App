import 'package:flutter/material.dart';
import '../../widgets/adoptive.dart';
import '../../widgets/listdrawer.dart';
import '../../widgets/simple_app_widget.dart';
import 'package:pilamokowebadmin/routes/routes.dart' as routes;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    if(isDesktop){
      return SafeArea(
        child: Scaffold(
          appBar: SimpleAppBar(),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: ListDrawer(item: 6,),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Colors.blueAccent.shade400,
                        ),
                        child: Image.asset("assets/images/logo.PNG",
                        width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Username"
                            ),
                          )),
                      SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Password"
                            ),
                          )),
                      SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Name"
                            ),
                          )),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).restorablePushNamed(routes.editprofile);

                        },
                        child: Container(
                          alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueAccent.shade400
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  "Edit Profile",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            )),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else {
      return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            drawer: ListDrawer(item: 6),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Colors.blueAccent.shade400,
                        ),
                        child: Image.asset("assets/images/logo.PNG",
                          width: 120,
                          height: 120,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Username"
                            ),
                          )),
                      SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Password"
                            ),
                          )),
                      SizedBox(height: 10),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "Name"
                            ),
                          )),
                      SizedBox(height: 30),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).restorablePushNamed(routes.editprofile);

                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueAccent.shade400
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400
                                ),
                              ),
                            )),
                      ),

                    ],
                  ),
                ),
              ],
            ),
        ),
      );
    }
  }
}
