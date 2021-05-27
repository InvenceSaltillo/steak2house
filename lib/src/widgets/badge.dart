import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';

import '../constants.dart';

class BadgeWidget extends StatelessWidget {
  BadgeWidget({
    Key? key,
  }) : super(key: key);

  final bottomNavCtrl = Get.find<BottomNavigationBarController>();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: -2,
      child: Bounce(
        duration: Duration(milliseconds: 800),
        from: 10,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: bottomNavCtrl.currentPage.value == 3
                ? Colors.red
                : kSecondaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}
