import 'package:flutter/material.dart';
import 'package:steak2house/src/screens/orders/orders_screen.dart';
import 'package:steak2house/src/screens/product_detail/product_detail_screen.dart';
import 'package:steak2house/src/screens/sign_in/sign_in_screen.dart';

import 'screens/home/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
  ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
};
