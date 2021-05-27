import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/categories_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/screens/cart/cart_screen.dart';
import 'package:steak2house/src/screens/checkout/checkout_screen.dart';
import 'package:steak2house/src/screens/credit_cards/my_credit_cards/my_credit_cards.dart';
import 'package:steak2house/src/screens/favorites/favorites_screen.dart';
import 'package:steak2house/src/screens/home/widgets/body_home.dart';
import 'package:steak2house/src/screens/notifications/notifications_screen.dart';
import 'package:steak2house/src/screens/orders/orders_screen.dart';
import 'package:steak2house/src/screens/orders/widgets/order_detail.dart';
import 'package:steak2house/src/services/category_service.dart';
import 'package:steak2house/src/services/payment_service.dart';
import 'package:steak2house/src/services/products_service.dart';
import 'package:steak2house/src/services/user_service.dart';
import 'package:steak2house/src/widgets/custom_bottom_bar.dart';

import 'widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final bottomNavCtrl = Get.find<BottomNavigationBarController>();
  final _miscCtrl = Get.find<MiscController>();
  final _userCtrl = Get.find<UserController>();
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // final categoriesCtrl = Get.find<CategoriesController>();
      final productsCtrl = Get.find<ProductController>();

      print('CONEKTAAAAA ${_userCtrl.user.value.conektaCustomerId}');
      if (_userCtrl.user.value.conektaCustomerId != null) {
        PaymentService.instance.getConektaCustomer();
      }
      CategoryService.instance.getCategories();

      if (productsCtrl.products.length == 0) {
        ProductService.instance.getByCategory(
          '1',
        );
      }

      if (productsCtrl.fromOtherPage['otherPage'] == true) {
        bottomNavCtrl.pageCtrl.value
            .jumpToPage(productsCtrl.fromOtherPage['index'] ?? 0);
        bottomNavCtrl.currentPage.value =
            productsCtrl.fromOtherPage['index'] ?? 0;
        productsCtrl.fromOtherPage['otherPage'] = false;
      }

      UserService.instance.getOrders();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CategoriesController());
    return Obx(
      () => Scaffold(
        appBar: _miscCtrl.showAppBar.value
            ? HomeAppBar()
            : PreferredSize(
                child: Container(),
                preferredSize: Size(0, 0),
              ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: bottomNavCtrl.pageCtrl.value,
          children: [
            BodyHomeScreen(),
            OrdersScreen(),
            FavoriteScreen(),
            CartScreen(),
            NotificationsScreen(),
            CheckOutScreen(),
            OrderDetail(),
            MyCreditCards(),
          ],
        ),
        bottomNavigationBar:
            _miscCtrl.showAppBar.value ? CustomBottomBar() : null,
      ),
    );
  }
}
