import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

class CustomBottomBar extends StatelessWidget {
  final _utils = Utils.instance;
  final bottomNavCtrl = Get.find<BottomNavigationBarController>();
  final _cartCtrl = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        onTap: (index) {
          bottomNavCtrl.currentPage.value = index;
          bottomNavCtrl.pageCtrl.value.animateToPage(
            index,
            duration: Duration(milliseconds: 400),
            curve: Curves.decelerate,
          );
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
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.shopping_cart_outlined),
                if (_cartCtrl.cartList.length > 0)
                  Positioned(
                    right: 0,
                    top: -2,
                    child: Bounce(
                      duration: Duration(milliseconds: 800),
                      from: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
