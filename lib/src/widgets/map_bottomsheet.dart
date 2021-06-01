import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import 'package:steak2house/src/widgets/map_view.dart';
import 'package:steak2house/src/widgets/rounded_button.dart';

class MapBottomSheet extends StatelessWidget {
  MapBottomSheet({
    Key? key,
  }) : super(key: key);

  final Utils _utils = Utils.instance;
  final _locationCtrl = Get.find<LocationController>();

  final _miscCtrl = Get.find<MiscController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: _utils.getHeightPercent(.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                    Dialogs.instance.showLocationBottomSheet();
                  },
                  icon: Icon(Icons.arrow_back_ios),
                )
              ],
            ),
            Text(
              'Confirma tu dirección',
              style: TextStyle(
                fontSize: _utils.getHeightPercent(.038),
                fontWeight: FontWeight.bold,
              ),
            ),
            MapView(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dirección',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.025),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_locationCtrl.currentAddress.value.results![0].formattedAddress!.split(',')[0]}, ${_locationCtrl.currentAddress.value.results![0].formattedAddress!.split(',')[1]}.',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.02),
                      color: Colors.black38,
                    ),
                  ),
                  Divider(
                    color: kPrimaryColor,
                  ),
                  Text(
                    'Ciudad',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.025),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_locationCtrl.currentAddress.value.results![0].addressComponents![3].longName}, ',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.02),
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: _utils.getHeightPercent(.07)),
            RoundedButton(
                text: 'Confirmar',
                fontSize: .025,
                width: .45,
                onTap: () async {
                  final exist = _locationCtrl.addressesList.where((address) =>
                      address.results![0].placeId ==
                      _locationCtrl.currentAddress.value.results![0].placeId);

                  if (exist.isBlank == true) {
                    _locationCtrl.addressesList
                        .add(_locationCtrl.currentAddress.value);
                    final listJ = json.encode(_locationCtrl.addressesList);

                    await SharedPrefs.instance.setKey('addresses', listJ);
                  }
                  _locationCtrl.tempAddress.value =
                      _locationCtrl.currentAddress.value;
                  _miscCtrl.updateDeliveryPrice();
                  Get.back();
                }),
            // TextButton(
            //   onPressed: () async {
            //     final exist = _locationCtrl.addressesList.where((address) =>
            //         address.results![0].placeId ==
            //         _locationCtrl.currentAddress.value.results![0].placeId);

            //     if (exist.isBlank == true) {
            //       _locationCtrl.addressesList
            //           .add(_locationCtrl.currentAddress.value);
            //       final listJ = json.encode(_locationCtrl.addressesList);

            //       await SharedPrefs.instance.setKey('addresses', listJ);
            //     }
            //     _locationCtrl.tempAddress.value =
            //         _locationCtrl.currentAddress.value;
            //     _miscCtrl.updateDeliveryPrice();
            //     Get.back();
            //   },
            //   style: TextButton.styleFrom(
            //     minimumSize: Size(_utils.getWidthPercent(.08), 10),
            //     fixedSize: Size(
            //       _utils.getWidthPercent(.8),
            //       _utils.getHeightPercent(.05),
            //     ),
            //     backgroundColor: Colors.green,
            //     padding: EdgeInsets.all(_utils.getHeightPercent(.01)),
            //   ),
            //   child: Text(
            //     'Confirmar',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontWeight: FontWeight.bold,
            //       fontSize: _utils.getHeightPercent(.02),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
