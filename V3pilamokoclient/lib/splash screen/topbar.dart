import 'package:flutter/material.dart';
import 'package:v3pilamokoemall/screens/cartscreen/track_orders/cancelled.dart';
import 'package:v3pilamokoemall/screens/cartscreen/track_orders/delivered.dart';
import 'package:v3pilamokoemall/screens/cartscreen/track_orders/my_orders.dart';
import 'package:v3pilamokoemall/screens/cartscreen/track_orders/ongoing.dart';
import 'package:v3pilamokoemall/screens/cartscreen/track_orders/pending.dart';


class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar>
    with SingleTickerProviderStateMixin
  {
  late  TabController controller;
  
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text("Track your Order",
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      centerTitle: true,
      bottom: TabBar(
        isScrollable: true,
        controller: controller,
        tabs: const [
          Tab(text: "All"),
          Tab(text: "Pending"),
          Tab(text: "Ongoing"),
          Tab(text: "Cancelled"),
          Tab(text: "Delivered"),
        ],
      ),
    ),
    body: TabBarView(
      controller: controller,
      children: [
        MyOrders(),
        Pending(),
        Ongoing(),
        Cancelled(),
        Delivered(),
      ],
    ),
  );
}
