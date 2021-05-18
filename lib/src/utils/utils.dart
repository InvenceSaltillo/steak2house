import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/services/products_service.dart';

class Utils {
  Utils._internal();
  static Utils _instance = Utils._internal();
  static Utils get instance => _instance;
  final Size size = Get.size;
  final String urlBackend = 'http://localhost/steak2house-backend/';
  // final String urlBackend = 'http://192.168.0.8/steak2house-backend/';

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
}
