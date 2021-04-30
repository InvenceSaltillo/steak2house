import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:steak2house/src/screens/home/home_screen.dart';
import 'package:steak2house/src/screens/home/widgets/custom_drawer.dart';

class MainScreen extends StatelessWidget {
  static String routeName = "/main_screen";
  final _drawerController = ZoomDrawerController();

  final List<MenuItem> options = [
    MenuItem(Icons.payment, 'Payments'),
    MenuItem(Icons.favorite, 'Discounts'),
    MenuItem(Icons.notifications, 'Notification'),
    MenuItem(Icons.format_list_bulleted, 'Orders'),
    MenuItem(Icons.help, 'Help'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZoomDrawer(
        controller: _drawerController,
        style: DrawerStyle.Style1,
        menuScreen: CustomDrawer(),
        mainScreen: HomeScreen(),
        borderRadius: 24.0,
        // showShadow: true,
        angle: 0.0,

        slideWidth: MediaQuery.of(context).size.width *
            (ZoomDrawer.isRTL() ? .45 : 0.65),
        // openCurve: Curves.fastOutSlowIn,
        // closeCurve: Curves.bounceIn,
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  MenuItem(this.icon, this.title);
}
