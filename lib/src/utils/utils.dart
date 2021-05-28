import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/services/products_service.dart';

class Utils {
  Utils._internal();
  static Utils _instance = Utils._internal();
  static Utils get instance => _instance;
  final Size size = Get.size;
  // final String urlBackend = 'https://invence.com.mx/steak2house/api/';
  final String urlBackend = 'http://localhost/steak2house-backend/';
  // final String urlBackend = 'http://192.168.0.14/steak2house-backend/';

  Timer _debounce = Timer(Duration(milliseconds: 500), () {});

  double getWidthPercent(double percent) {
    return size.width * percent;
  }

  double getHeightPercent(double percent) {
    return size.height * percent;
  }

  debounce(String search) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ProductService.instance.searchProducts(search);
    });
  }

  String quitZeros(String value) {
    return double.parse(value.substring(0, value.length - 2))
        .toStringAsFixed(2);
  }

  Widget getCardBrandIcon(String brand, Color color) {
    switch (brand) {
      case 'visa':
        return FaIcon(FontAwesomeIcons.ccVisa, color: color);
      case 'mastercard':
        return FaIcon(FontAwesomeIcons.ccMastercard, color: color);
      case 'american_express':
        return FaIcon(FontAwesomeIcons.ccAmex, color: color);
      default:
        return FaIcon(FontAwesomeIcons.creditCard, color: color);
    }
  }
}
