import 'package:flutter/material.dart';
import 'package:pilamokowebadmin/widgets/popupmenu.dart';
import 'package:pilamokowebadmin/routes/routes.dart' as routes;
import 'custom_text.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget {

  final  PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom});
  @override
  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
  Widget build(BuildContext context) {
    return AppBar(
      leading: Row(
        children: [
          PopUpMen(
            menuList: [
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                  ),
                  title: Text("Log Out"),
                  onTap: (){
                    Navigator.restorablePushNamed(context, routes.defaultRoute);
                  },
                ),
              ),
            ],
            icon: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo.PNG"),
            ),
          ),
        ],
      ),
      title: Row(
        children: [
          CustomText(
            text: "PILAMOKO ADMIN",
            color: Colors.white,
            size: 20,
            weight: FontWeight.bold,
          ),
          Container(
            height: 25,

          ),
          SizedBox(
            width: 24,
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25)),
            child: Container(
              padding: EdgeInsets.all(1),
              margin: EdgeInsets.all(1),
            ),
          ),
        ],
      ),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 10.0, right: 10),
        //   child: CustomText(
        //     text: sharedPreferences!.getString("name")!,
        //     color: Colors.white,
        //     size: 20,
        //     weight: FontWeight.bold,
        //   ),
        // )
      ],
      backgroundColor: Colors.blueAccent,
    );
  }
}