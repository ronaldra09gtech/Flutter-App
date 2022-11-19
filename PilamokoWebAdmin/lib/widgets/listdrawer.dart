import 'package:flutter/material.dart';
import 'package:pilamokowebadmin/widgets/simple_app_widget.dart';
import 'adoptive.dart';
import 'package:pilamokowebadmin/routes/routes.dart' as routes;

class ListDrawer extends StatefulWidget {
  ListDrawer({this.item});
  int? item;
  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    return Drawer(
      backgroundColor: Colors.blueAccent,
      child: SafeArea(
        child: ListView(
          children: [
            !isDesktop
                ? Container(
              height: 100,
              padding: EdgeInsets.all(8),
              child: SimpleAppBar(),
            )
                : Container(),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 1 == widget.item,
              leading: const Icon(Icons.dashboard,color: Colors.black,),
              title: Row(
                children: [
                  Text(
                    "Dashboard",
                    style: TextStyle(
                        color: Colors.black,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  widget.item = 1;
                });
                Navigator.of(context).restorablePushNamed(routes.dashboard);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 2 == widget.item,
              leading: const Icon(Icons.list,color: Colors.black),
              title: Text(
                "Pilamoko Queuer",
                style: TextStyle(
                    color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 2;
                });
                Navigator.of(context).restorablePushNamed(routes.queuer);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 3 == widget.item,
              leading: const Icon(Icons.room_outlined,color: Colors.black),
              title: Text(
                "Pilamoko TLP",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 3;
                });
                Navigator.of(context).restorablePushNamed(routes.tlp);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 4 == widget.item,
              leading: const Icon(Icons.shopping_bag,color: Colors.black),
              title: Text(
                "Pilamoko Merchant",
                style: TextStyle(
                    color: Colors.black,
                  fontWeight: FontWeight.w400,

                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 4;
                });
                Navigator.of(context).restorablePushNamed(routes.merchant);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 5 == widget.item,
              leading: const Icon(Icons.supervised_user_circle,color: Colors.black),
              title: Text(
                "Client",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 5;
                });
                Navigator.of(context).restorablePushNamed(routes.client);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 6 == widget.item,
              leading: const Icon(Icons.supervised_user_circle,color: Colors.black),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 6;
                });
                Navigator.of(context).restorablePushNamed(routes.profile);
              },
            ),
            SizedBox(height: 30,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Services",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 7 == widget.item,
              leading: const Icon(Icons.motorcycle_outlined,color: Colors.black),
              title: Text(
                "Paki-dala",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 7;
                });
                //Navigator.of(context).restorablePushNamed(routes.profile);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 8 == widget.item,
              leading: const Icon(Icons.file_copy_outlined,color: Colors.black),
              title: Text(
                "Document Filling Assistance",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 8;
                });
                Navigator.of(context).restorablePushNamed(routes.dfa);
              },
            ),
            ListTile(
              hoverColor: Colors.white,
              selectedTileColor: Colors.white,
              selectedColor: Colors.white,
              enabled: true,
              selected: 9 == widget.item,
              leading: const Icon(Icons.warehouse_outlined,color: Colors.black),
              title: Text(
                "E-Mall",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onTap: () {
                setState(() {
                  widget.item = 9;
                });
                //Navigator.of(context).restorablePushNamed(routes.profile);
              },
            ),

          ],
        ),
      ),
    );
  }
}