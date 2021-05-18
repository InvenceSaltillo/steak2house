import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/bottom_navigation_bar_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class EmptyCart extends StatelessWidget {
  EmptyCart({
    Key? key,
  }) : super(key: key);

  final _bottomNavCtrl = Get.find<BottomNavigationBarController>();
  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/img/emptyCart.svg',
            width: _utils.getWidthPercent(.7),
          ),
          Text(
            'Tu carrito esta vacío',
            style: TextStyle(
              fontSize: _utils.getHeightPercent(.025),
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          Container(
            width: _utils.getWidthPercent(.5),
            child: Text(
              'Parece que no haz agregado ningun producto aún',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          SizedBox(height: _utils.getHeightPercent(.02)),
          TextButton(
            onPressed: () async {
              _bottomNavCtrl.pageCtrl.value.jumpTo(
                0,
                // duration: Duration(milliseconds: 700),
                // curve: Curves.decelerate,
              );
              _bottomNavCtrl.currentPage.value = 0;
            },
            style: TextButton.styleFrom(
              minimumSize: Size(_utils.getWidthPercent(.4), 20),
              backgroundColor: kPrimaryColor,
              padding: EdgeInsets.all(_utils.getHeightPercent(.01)),
            ),
            child: Text(
              'Empieza a comprar',
              style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: _utils.getHeightPercent(.02),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
