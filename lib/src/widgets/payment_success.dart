import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/utils/utils.dart';

class PaymentSuccess extends StatefulWidget {
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  final _miscCtrl = Get.find<MiscController>();

  final _bottomNavCtrl = Get.find<BottomNavigationBarController>();

  final _utils = Utils.instance;

  Future<void> goBack() async {
    await Future.delayed(Duration(milliseconds: 2500));
    _miscCtrl.showAppBar.value = true;

    _bottomNavCtrl.currentPage.value = 0;
    _bottomNavCtrl.pageCtrl.value.jumpToPage(0);

    Get.offUntil(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return MainScreen();
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
      (route) => false,
    );
    // Get.back();
  }

  @override
  void initState() {
    goBack();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/paymentSuccess.json'),
          Pulse(
            child: Text(
              '¡Pago exitoso!'.toUpperCase(),
              style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: _utils.getWidthPercent(.08),
              ),
            ),
          )
        ],
      ),
    );
  }
}
