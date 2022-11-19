import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/eresto/eresto_items_screen.dart';
import 'package:plmclient/client/models/eresto/eresto_menus.dart';
import 'package:plmclient/client/models/eresto/eresto.dart';

class ErestoMenusDesignWidget extends StatefulWidget {

  ErestoMenus? model;
  BuildContext? context;

  ErestoMenusDesignWidget({this.model, this.context});

  @override
  _ErestoMenusDesignWidgetState createState() => _ErestoMenusDesignWidgetState();
}

class _ErestoMenusDesignWidgetState extends State<ErestoMenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ErestoItemsScreen(model: widget.model)));
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
