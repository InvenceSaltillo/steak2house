import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/screens/home/home_screen.dart';
import 'package:steak2house/src/screens/home/widgets/custom_drawer.dart';

class MainScreen extends StatelessWidget {
  static String routeName = "/main_screen";
  final _drawerController = ZoomDrawerController();
  late final bottomNavCtrl = Get.find<BottomNavigationBarController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (bottomNavCtrl.currentPage.value != 0) {
            bottomNavCtrl.currentPage.value = 0;
            bottomNavCtrl.pageCtrl.value.jumpToPage(0);
          } else {
            Get.defaultDialog(
              title: 'Salir',
              middleText: '¿Quieres salir de Steak2House?',
              confirmTextColor: Colors.red,
              confirm: ElevatedButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text('Salir'),
                style: ElevatedButton.styleFrom(
                  primary: kSecondaryColor,
                ),
              ),
              cancel: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('No'),
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                ),
              ),
            );
          }
          return false;
        },
        child: ZoomDrawer(
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
      ),
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  MenuItem(this.icon, this.title);
}
