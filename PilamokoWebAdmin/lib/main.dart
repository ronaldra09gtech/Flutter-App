import 'package:flutter/material.dart';
import 'package:pilamokowebadmin/screens/dashboard/dashboard.dart';
import 'package:pilamokowebadmin/screens/document_filling_assistance.dart';
import 'package:pilamokowebadmin/screens/edit_profile/edit_profile.dart';
import 'autthentication_page/auth_scrn.dart';
import 'package:pilamokowebadmin/routes/routes.dart' as routes;
import 'package:pilamokowebadmin/screens/queuer_scrn.dart';
import 'package:pilamokowebadmin/screens/tlp_scrn.dart';
import 'package:pilamokowebadmin/screens/merchant_scrn.dart';
import 'package:pilamokowebadmin/screens/edit_profile/profile.dart';
import 'package:pilamokowebadmin/screens/client_scrn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: routes.defaultRoute,
      onUnknownRoute: (RouteSettings settings) {
        Navigator.of(context).restorablePushNamed(routes.defaultRoute);
      },
      routes: {
        routes.defaultRoute: (context) => AuthenticationPage(),
        routes.dashboard: (context) => DashBoard(),
        routes.queuer: (context) => QueuerScreen(),
        routes.tlp: (context) => TLPScreen(),
        routes.merchant: (context) => MerchantScreen(),
        routes.profile: (context) => Profile(),
        routes.client: (context) => ClientScreen(),
        routes.dfa: (context) => DocumentFillingAssistance(),
        routes.editprofile: (context) => EditProfile(),
      },
    );
  }
}

