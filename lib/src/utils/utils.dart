import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  Utils._internal();
  static Utils _instance = Utils._internal();
  static Utils get instance => _instance;
  final Size size = Get.size;
  // final String urlBackend = 'http://localhost/steak2house-backend/';
  final String urlBackend = 'http://192.168.0.15/steak2house-backend/';

  double getWidthPercent(double percent) {
    return size.width * percent;
  }

  double getHeightPercent(double percent) {
    return size.height * percent;
  }
}
