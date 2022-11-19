import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:v3pilamokoemall/screens/homescreen/homescreen.dart';
import 'package:v3pilamokoemall/screens/menus_screen/item_screen.dart';
import '../../assistantMethods/cart_item_counter.dart';
import '../add_to_cart_screen/add_cart_screen.dart';
import '../dataHandler/emall_data.dart';

class MenusScreen extends StatefulWidget {
  final Emalldata? model;
  MenusScreen({this.model});
  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .75,
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.blue,),
                      onPressed: ()
                      {
                        //send to cart Screen
                        Navigator.push(context, MaterialPageRoute(builder: (c)=> SideBarLayoutHome(page: 3,)));
                      },
                    ),
                    Positioned(
                      right: 1,
                      child: Stack(
                        children:  [
                          const Icon(
                            Icons.brightness_1,
                            size: 20.0,
                            color: Colors.blue,
                          ),
                          Positioned(
                            top: 5,
                            right: 6,
                            child: Center(
                              child: Consumer<CartItemCounter>(
                                builder: (context, counter, c)
                                {
                                  return Text(
                                      counter.count.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 12)
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(2),
              child: Text('${widget.model!.shopName!} Products List'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("pilamokoemall")
                  .doc(widget.model!.pilamokosellerUID)
                  .collection("menus")
                  .orderBy("publishDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) { // Check the status here
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: GridView.count(
                    crossAxisCount: 2,
                    controller: ScrollController(keepScrollOffset: false),
                    shrinkWrap: true,
                    childAspectRatio: (itemWidth / itemHeight),
                    scrollDirection: Axis.vertical,
                    children: snapshot.data!.docs.map((document) {
                      return InkWell(
                        onTap: (){
                          EmallMenus? emallmenus = EmallMenus();
                          emallmenus.pilamokosellerUID = document['pilamokoemallUID'];
                          emallmenus.menuTitle = document['menuTitle'];
                          emallmenus.menuID = document['menuID'];
                          emallmenus.shopName = widget.model!.shopName!;
                          Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemScreen(model: emallmenus)));
                        },
                        child: Container(
                          color: Colors.grey.withOpacity(0.2),
                          margin: EdgeInsets.all(1.0),
                          child: Column(
                            children: [
                              Container(
                                height: 190,
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(document["thumbnailUrl"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Category"),
                                    Text(document['menuTitle']),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Info"),
                                    Text(document['menuInfo']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
