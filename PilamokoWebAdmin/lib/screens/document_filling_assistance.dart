import 'package:flutter/material.dart';
import '../widgets/adoptive.dart';
import '../widgets/listdrawer.dart';
import '../widgets/simple_app_widget.dart';



class DocumentFillingAssistance extends StatelessWidget {
  const DocumentFillingAssistance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);
    if(isDesktop){
      return SafeArea(
        child: Scaffold(
          appBar: SimpleAppBar(),
          body: Row(
            children: [
              Expanded(
                flex: 1,
                child: ListDrawer(item: 8,),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(

                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text('Foo'),
                      VerticalDivider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Text('Bar'),
                      VerticalDivider(),
                      Text('Baz'),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: TextField(
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.blueAccent)
                                    ),
                                    hintText: 'Search',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18
                                    ),
                                    prefixIcon: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(Icons.search),
                                      width: 18,
                                    )
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent,
                            )
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('My Awesome Border'),
                                Text('My Awesome Border'),
                                Text('My Awesome Border'),
                                Text('My Awesome Border'),
                              ],
                            ),
                          ],
                        ),
                      )
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
            drawer: ListDrawer(item: 8),
            body: Container()
        ),
      );
    }
  }
}