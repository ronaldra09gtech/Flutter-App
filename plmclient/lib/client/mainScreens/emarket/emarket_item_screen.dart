import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:plmclient/client/models/emarket/emarket_items.dart';
import 'package:plmclient/client/models/emarket/emarket_menus.dart';
import 'package:plmclient/client/widgets/app_bar.dart';
import 'package:plmclient/client/widgets/emarket/emarket_items_design.dart';
import 'package:plmclient/client/widgets/progress_bar.dart';
import 'package:plmclient/client/widgets/text_widget_header.dart';


class EmarketItemsScreen extends StatefulWidget {
  final EmarketMenus? model;
  EmarketItemsScreen({this.model});

  @override
  _EmarketItemsScreenState createState() => _EmarketItemsScreenState();
}

class _EmarketItemsScreenState extends State<EmarketItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(pilamokosellerUID: widget.model!.pilamokosellerUID),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: TextWidgetHeader(title: "Items of " + widget.model!.menuTitle.toString())),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("pilamokoemarket")
                .doc(widget.model!.pilamokosellerUID)
                .collection("menus")
                .doc(widget.model!.menuID)
                .collection("items")
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
                  EmarketItems model = EmarketItems.fromJson(
                    snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                  );
                  return EmarketItemsDesignWidget(
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
