import 'package:flutter/material.dart';
import 'package:pilamokowebadmin/widgets/info_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../widgets/adoptive.dart';
import '../../widgets/listdrawer.dart';
import '../../widgets/simple_app_widget.dart';



class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {

  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40),
    _SalesData('Jun', 30),
    _SalesData('Jul', 55),
    _SalesData('Aug', 70),
    _SalesData('Sept', 40),
    _SalesData('Oct', 90),
    _SalesData('Nov', 110),
    _SalesData('Dec', 480),


  ];
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
                child: ListDrawer(item: 1,),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InfoCard(
                            title: "TLP",
                            value: "220",
                            topColor: Colors.lightBlue,
                            onTap: (){},
                          ),
                          InfoCard(
                            title: "Queuer",
                            value: "80",
                            topColor: Colors.lightBlue,
                            onTap: (){},
                          ),
                          InfoCard(
                            title: "Merchant",
                            value: "590",
                            topColor: Colors.lightBlue,
                            onTap: (){},
                          ),
                          InfoCard(
                            title: "Client",
                            value: "381",
                            topColor: Colors.lightBlue,
                            onTap: (){},
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent.shade400
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.60,
                        width: MediaQuery.of(context).size.width * 90,
                        child: Column(
                          children: [
                            SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                title: ChartTitle(text: 'Sales Analysis'),
                                legend: Legend(isVisible: true),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<_SalesData, String>>[
                                  LineSeries<_SalesData, String>(
                                      dataSource: data,
                                      xValueMapper: (_SalesData sales, _) => sales.year,
                                      yValueMapper: (_SalesData sales, _) => sales.sales,
                                      name: 'TLP Monitoring',
                                      // Enable data label
                                      dataLabelSettings: DataLabelSettings(isVisible: true))
                                ]),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                //Initialize the spark charts widget
                                child: SfSparkLineChart.custom(
                                  //Enable the trackball
                                  trackball: SparkChartTrackball(
                                      activationMode: SparkChartActivationMode.tap),
                                  //Enable marker
                                  marker: SparkChartMarker(
                                      displayMode: SparkChartMarkerDisplayMode.all),
                                  //Enable data label
                                  labelDisplayMode: SparkChartLabelDisplayMode.all,
                                  xValueMapper: (int index) => data[index].year,
                                  yValueMapper: (int index) => data[index].sales,
                                  dataCount: 10,
                                ),
                              ),
                            )
                          ],),
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
          drawer: ListDrawer(item: 1),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    InfoCard(
                      title: "TLP",
                      value: "220",
                      topColor: Colors.lightBlue,
                      onTap: (){},
                    ),
                    InfoCard(
                      title: "Queuer",
                      value: "80",
                      topColor: Colors.lightBlue,
                      onTap: (){},
                    ),
                    InfoCard(
                      title: "Merchant",
                      value: "590",
                      topColor: Colors.lightBlue,
                      onTap: (){},
                    ),
                    InfoCard(
                      title: "Client",
                      value: "381",
                      topColor: Colors.lightBlue,
                      onTap: (){},
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blueAccent.shade400
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width * 90,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 10,
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            title: ChartTitle(text: 'Sales Analysis'),
                            legend: Legend(isVisible: true),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                  dataSource: data,
                                  xValueMapper: (_SalesData sales, _) => sales.year,
                                  yValueMapper: (_SalesData sales, _) => sales.sales,
                                  name: 'TLP Monitoring',
                                  // Enable data label
                                  dataLabelSettings: DataLabelSettings(isVisible: true))
                            ]),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            //Initialize the spark charts widget
                            child: SfSparkLineChart.custom(
                              //Enable the trackball
                              trackball: SparkChartTrackball(
                                  activationMode: SparkChartActivationMode.tap),
                              //Enable marker
                              marker: SparkChartMarker(
                                  displayMode: SparkChartMarkerDisplayMode.all),
                              //Enable data label
                              labelDisplayMode: SparkChartLabelDisplayMode.all,
                              xValueMapper: (int index) => data[index].year,
                              yValueMapper: (int index) => data[index].sales,
                              dataCount: 10,
                            ),
                          ),
                        )
                      ],),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}