import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../global/global.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});


  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  late AnimationController _animationController;
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenSink;
  final _animationDuration = const Duration(milliseconds: 500);


  @override
  void initState() {
    super.initState();
    _animationController =AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenSink.close();
    super.dispose();
  }

  void onIconPressed(){
    var animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted){
      isSidebarOpenSink.add(false);
      _animationController.reverse();
    }else{
      isSidebarOpenSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync){
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data! ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data! ? 0 : screenWidth - 41,
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(top: 60, left: 5),
                    height: MediaQuery.of(context).size.height,
                    color: const Color(0xFF262AAA),
                    child: Column(
                      children: [
                        Row(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/logo.PNG",
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 6),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(sharedPreferences!.getString("name")!,
                                //   style: const TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.w600
                                //   ),),
                                // Text(sharedPreferences!.getString("email")!,
                                //   style: const TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 15,
                                //   ),),
                              ],
                            )
                          ],
                        ),
                        const Divider(
                          height: 60,
                          thickness: 2,
                          color: Colors.white,
                          indent: 4,
                          endIndent: 32,
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  Icons.home_filled,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 15,),
                                Text("Home",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                      color: Colors.white
                                  ),)
                              ],
                            ),
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => const SideBarLayoutHome() ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  Icons.person_pin,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 15,),
                                Text("Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                      color: Colors.white
                                  ),)
                              ],
                            ),
                            onTap: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => const SideBarLayoutProfile() ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 15,),
                                Text("My Queuers",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                      color: Colors.white
                                  ),)
                              ],
                            ),
                            onTap: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => const MyQueuers() ));

                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 15,),
                                Text("Zone",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Colors.white,

                                  ),)
                              ],
                            ),
                            onTap: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => const ZoneLayout() ));
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                SizedBox(width: 15,),
                                Text("Logout",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                      color: Colors.white
                                  ),)
                              ],
                            ),
                            onTap: (){
                              // Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen() ));
                            },
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.26),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Text("Powered By:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                            Text("Platinum R-1 Technology\nSolutions Corporation",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: (){
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 40,
                      height: 110,
                      color: const Color(0xFF262AAA),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

