import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

class CustomBottomBar extends StatelessWidget {
  final _utils = Utils.instance;
  final bottomNavCtrl = Get.find<BottomNavigationBarController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        onTap: (index) {
          bottomNavCtrl.currentPage.value = index;
          bottomNavCtrl.pageCtrl.value.jumpToPage(index);
        },
        backgroundColor: kPrimaryColor,
        selectedItemColor: kSecondaryColor,
        unselectedItemColor: Colors.white,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: bottomNavCtrl.currentPage.value,
        iconSize: _utils.getHeightPercent(.030),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: 'Mis pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notificaciones',
          ),
        ],
      ),
    );
  }
}
