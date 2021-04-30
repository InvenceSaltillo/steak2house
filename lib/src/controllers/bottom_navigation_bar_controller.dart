import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationBarController extends GetxController {
  var currentPage = 0.obs;
  var pageCtrl = new PageController().obs;

  var isHide = false.obs;
}
