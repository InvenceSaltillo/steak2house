import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/categories_controller.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/screens/cart/cart_screen.dart';
import 'package:steak2house/src/screens/favorites/favorites_screen.dart';
import 'package:steak2house/src/screens/home/widgets/body_home.dart';
import 'package:steak2house/src/screens/notifications/notifications_screen.dart';
import 'package:steak2house/src/screens/orders/orders_screen.dart';
import 'package:steak2house/src/services/category_service.dart';
import 'package:steak2house/src/services/products_service.dart';
import 'package:steak2house/src/widgets/custom_bottom_bar.dart';

import 'widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final bottomNavCtrl = Get.find<BottomNavigationBarController>();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // final categoriesCtrl = Get.find<CategoriesController>();
      final productsCtrl = Get.find<ProductController>();

      CategoryService.instance.getCategories();

      if (productsCtrl.products.length == 0) {
        ProductService.instance.getByCategory(
          '1',
        );
      }

      if (productsCtrl.fromFavorites.value) {
        bottomNavCtrl.pageCtrl.value.jumpToPage(2);
        bottomNavCtrl.currentPage.value = 2;
        productsCtrl.fromFavorites.value = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CategoriesController());
    Get.put(ProductController());
    return Scaffold(
      appBar: HomeAppBar(),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: bottomNavCtrl.pageCtrl.value,
        children: [
          BodyHomeScreen(),
          OrdersScreen(),
          FavoriteScreen(),
          CartScreen(),
          NotificationsScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(),
    );
  }
}
