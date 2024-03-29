import 'package:flutter/material.dart';
import 'package:plmclient/merchat/mall/mainScreens/orders/accepted_orders.dart';
import 'package:plmclient/merchat/mall/mainScreens/orders/completed_orders.dart';
import 'package:plmclient/merchat/mall/mainScreens/orders/new_orders_screen.dart';
import 'package:plmclient/merchat/mall/mainScreens/orders/ready_orders.dart';
import 'package:plmclient/merchat/mall/mainScreens/orders/shipped_orders.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
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
              "Orders",
            ),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: "New Orders",
                ),
                Tab(
                  text: "Accepted Orders",
                ),
                Tab(
                  text: "To Ship",
                ),
                Tab(
                  text: "Shipped",
                ),Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Cancelled",
                ),
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 2,
            ),
          ),
          body: TabBarView(
            children: [
              NewOrdersScreen(),
              AcceptedOrders(),
              ReadyOrders(),
              ShippedOrders(),
              CompletedOrders(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
