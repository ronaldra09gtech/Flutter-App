import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../widgets/adoptive.dart';
import '../widgets/listdrawer.dart';
import '../widgets/simple_app_widget.dart';


class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
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
                child: ListDrawer(item: 5,),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Text("Client List",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
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
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: Colors.blueAccent)
                                  ),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15
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
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent.shade400
                            ),
                            borderRadius: BorderRadius.circular(20)
                        ),
                        height: MediaQuery.of(context).size.height * 0.50,
                        width: MediaQuery.of(context).size.width * 90,
                        child: DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: 600,
                            columns: [
                              DataColumn2(
                                label: Text('Name'),
                                size: ColumnSize.L,
                              ),
                              DataColumn(
                                label: Text('Contact No.'),
                              ),
                              DataColumn(
                                label: Text('Zone'),
                              ),
                              DataColumn(
                                label: Text('Email'),
                              ),
                              DataColumn(
                                label: Text('Actions'),
                                
                              ),
                            ],
                            rows: List<DataRow>.generate(
                                1,
                                    (index) => DataRow(cells: [
                                  DataCell(Text('Lexter John')),
                                  DataCell(Text('09917748360')),
                                  DataCell(Text('Calauag, Quezon')),
                                  DataCell(Text('ljvalencia0302@gmail.com')),
                                      DataCell(Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.delete,
                                            color: Colors.blueAccent.shade400,
                                          ),
                                          SizedBox(width: 3),
                                          Icon(Icons.block,
                                            color: Colors.blueAccent.shade400,
                                          ),

                                        ],
                                      )),
                                ]))),
                      ),
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
            drawer: ListDrawer(item: 5),
            body: Container()
        ),
      );
    }
  }
}
