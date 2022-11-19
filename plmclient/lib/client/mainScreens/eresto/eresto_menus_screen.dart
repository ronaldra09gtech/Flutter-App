import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:plmclient/client/models/eresto/eresto_menus.dart';
import 'package:plmclient/client/models/eresto/eresto.dart';
import 'package:plmclient/client/widgets/eresto/eresto_menus_design.dart';
import 'package:plmclient/client/widgets/progress_bar.dart';
import 'package:plmclient/client/widgets/text_widget_header.dart';


class ERestoMenusScreen extends StatefulWidget {

  final Eresto? model;
  ERestoMenusScreen({this.model});
  @override
  _ERestoMenusScreenState createState() => _ERestoMenusScreenState();
}

class _ERestoMenusScreenState extends State<ERestoMenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.lightBlueAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Pilamoko",
          style: TextStyle(fontSize: 30, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: widget.model!.pilamokosellerName.toString() + "'s Menus")),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("pilamokoseller")
                .doc(widget.model!.pilamokosellerUID)
                .collection("menus")
                .orderBy("publishDate", descending: true)
                .snapshots(),
            builder: (context, snapshot)
            {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                child: Center(child: circularProgress(),),
              )
                  : SliverStaggeredGrid.countBuilder(
                crossAxisCount: 1,
                staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                itemBuilder: (context, index)
                {
                  ErestoMenus model = ErestoMenus.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return ErestoMenusDesignWidget(
                    model: model,
                    context: context,
                  );
                },
                itemCount: snapshot.data!.docs.length,
              );
            },
          ),
        ],
      ),
    );
  }
}
