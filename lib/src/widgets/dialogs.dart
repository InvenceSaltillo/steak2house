import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:open_settings/open_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/screens/credit_cards/credit_card_list/body_credit_card_list.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/utils/utils.dart';

import 'bottom_sheet_addresses.dart';
import 'map_bottomsheet.dart';

enum DialogType { success, error, info }

class Dialogs {
  Dialogs._internal();
  static Dialogs _instance = Dialogs._internal();
  static Dialogs get instance => _instance;

  final _utils = Utils.instance;

  void showLoadingProgress({
    required String message,
  }) {
    Get.dialog(
      Scaffold(
        backgroundColor: kPrimaryColor.withOpacity(.7),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    // CircularProgressIndicator(),
                    Lottie.asset(
                      'assets/animations/loading.json',
                      width: _utils.getWidthPercent(.5),
                      height: _utils.getWidthPercent(.5),
                    ),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: _utils.getHeightPercent(.025),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      useSafeArea: false,
      barrierDismissible: false,
    );
  }

  Future<void> showSnackBar(
      DialogType type, String text, bool? dissmiss) async {
    final iconRotationAngle = 32;
    final backgroundColor = type == DialogType.success
        ? Color(0xff00E676)
        : type == DialogType.info
            ? Color(0xff2196F3)
            : Color(0xffff5252);

    final icon = Icon(
      type == DialogType.success
          ? Icons.sentiment_very_satisfied
          : type == DialogType.info
              ? Icons.sentiment_neutral
              : Icons.error_outline,
      color: const Color(0x15000000),
      size: 70,
    );

    return Get.snackbar(
      '',
      '',
      messageText: Container(),
      backgroundColor: backgroundColor,
      forwardAnimationCurve: Curves.bounceInOut,
      animationDuration: Duration(milliseconds: 1200),
      duration: Duration(milliseconds: dissmiss! ? 1500 : 2000),
      padding: EdgeInsets.zero,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && dissmiss) {
          Get.off(() => MainScreen());
        }
      },
      titleText: Container(
        width: double.infinity,
        height: _utils.getHeightPercent(.07),
        child: Stack(
          children: [
            Positioned(
              top: -15,
              left: -8,
              child: ClipRRect(
                child: Container(
                  height: 95,
                  child: Transform.rotate(
                    angle: iconRotationAngle * pi / 180,
                    child: icon,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLocationBottomSheet() {
    Get.bottomSheet(
      BottomSheetAddresses(),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  void showMapBottomSheet() {
    Get.bottomSheet(
      MapBottomSheet(),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );
  }

  void showCardsBottomSheet() {
    Get.bottomSheet(
      BodyCreditCardList(),
      enableDrag: false,
      isDismissible: false,
    );
  }

  Future<void> showLocationDialog(
      {required String text, required bool gps}) async {
    final _locationCtrl = Get.find<LocationController>();

    Get.defaultDialog(
      title: '',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            LottieBuilder.asset('assets/animations/location.json'),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      confirm: TextButton(
        onPressed: () {
          Get.back();
          _locationCtrl.fromSettings.value = true;

          if (!gps) openAppSettings();
          if (gps) OpenSettings.openLocationSourceSetting();
        },
        style: TextButton.styleFrom(
          backgroundColor: kPrimaryColor,
          primary: Colors.white,
        ),
        child: Text('OK'),
      ),
      confirmTextColor: kPrimaryColor,
      barrierDismissible: false,
      onConfirm: () => Get.back(),
    );
  }

  Future<bool> showLottieDialog({
    required String title,
    required String lottieSrc,
    required String firstButtonText,
    required String secondButtonText,
    required Color firstButtonBgColor,
    required Color firstButtonTextColor,
    required Color secondButtonBgColor,
    required Color secondButtonTextColor,
    double lottieSize = .15,
  }) async {
    bool result = false;
    await Get.defaultDialog(
      title: '',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Lottie.asset(
              lottieSrc,
              height: _utils.getHeightPercent(lottieSize),
              repeat: false,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        if (firstButtonText != '')
          TextButton(
            onPressed: () async {
              Get.back();
              result = true;
            },
            style: TextButton.styleFrom(
              backgroundColor: firstButtonBgColor,
              primary: firstButtonTextColor,
            ),
            child: Text(firstButtonText),
          ),
        if (secondButtonText != '')
          TextButton(
            onPressed: () {
              Get.back();
              result = false;
            },
            style: TextButton.styleFrom(
              backgroundColor: secondButtonBgColor,
              primary: secondButtonTextColor,
            ),
            child: Text(secondButtonText),
          ),
      ],
      confirmTextColor: kPrimaryColor,
      barrierDismissible: false,
    );
    return result;
  }

  void dismiss() {
    Get.back();
  }
}
