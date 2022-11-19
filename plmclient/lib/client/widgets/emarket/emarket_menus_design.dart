import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/emarket/emarket_item_screen.dart';
import 'package:plmclient/client/mainScreens/eresto/eresto_items_screen.dart';
import 'package:plmclient/client/models/emarket/emarket_menus.dart';
import 'package:plmclient/client/models/eresto/eresto_menus.dart';
import 'package:plmclient/client/models/eresto/eresto.dart';

class EmarketMenusDesignWidget extends StatefulWidget {

  EmarketMenus? model;
  BuildContext? context;

  EmarketMenusDesignWidget({this.model, this.context});

  @override
  _EmarketMenusDesignWidgetState createState() => _EmarketMenusDesignWidgetState();
}

class _EmarketMenusDesignWidgetState extends State<EmarketMenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> EmarketItemsScreen(model: widget.model)));
      },
      splashColor: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 285,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 2.0,),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),

              Text(
                widget.model!.menuInfo!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
