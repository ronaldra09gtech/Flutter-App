import 'package:flutter/material.dart';
import 'package:plmclient/client/mainScreens/emall/emall_item_detail_screen.dart';
import 'package:plmclient/client/mainScreens/eresto/eresto_item_detail_screen.dart';
import 'package:plmclient/client/models/emall/emall_items.dart';
import 'package:plmclient/client/models/eresto/eresto_items.dart';

class EmallItemsDesignWidget extends StatefulWidget {

  EmallItems? model;
  BuildContext? context;

  EmallItemsDesignWidget({this.model, this.context});

  @override
  _EmallItemsDesignWidgetState createState() => _EmallItemsDesignWidgetState();
}

class _EmallItemsDesignWidgetState extends State<EmallItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> EmallItemDetailsScreen(model: widget.model)));
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
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: "Train",
                ),
              ),

              Text(
                widget.model!.shortInfo!,
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
