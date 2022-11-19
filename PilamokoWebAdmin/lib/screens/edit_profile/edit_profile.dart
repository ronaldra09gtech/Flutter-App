import 'package:flutter/material.dart';
import 'package:pilamokowebadmin/routes/routes.dart' as routes;
import '../../widgets/adoptive.dart';
import '../../widgets/listdrawer.dart';
import '../../widgets/simple_app_widget.dart';



class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
                    SizedBox(height: 30),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .2,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 10
                          ),
                          border: InputBorder.none,
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Username",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .2,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Name",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .2,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Password",
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * .2,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextFormField(
                        obscureText: true,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          focusColor: Theme.of(context).primaryColor,
                          hintText: "Confirm Password",
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        InkWell(
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.10,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent.shade400
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(width: 5),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).restorablePushNamed(routes.profile);
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.10,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.blueAccent.shade400
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Back",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )

                  ],
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(height: 30),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 10
                      ),
                      border: InputBorder.none,
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Username",
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Name",
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Password",
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .2,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                      focusColor: Theme.of(context).primaryColor,
                      hintText: "Confirm Password",
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    InkWell(
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.10,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.shade400
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Save Changes",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          )),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).restorablePushNamed(routes.profile);

                      },
                      child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.10,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.shade400
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          )),
                    ),
                  ],
                )

              ],
            ),
        ),
      );
    }
  }
}
