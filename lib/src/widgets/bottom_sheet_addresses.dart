import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';

import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../constants.dart';

class BottomSheetAddresses extends StatelessWidget {
  BottomSheetAddresses({
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
        // height: double.infinity,
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
                Spacer(),
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),
            Text(
              'Agrega o elige una ubicación',
              style: TextStyle(
                fontSize: _utils.getHeightPercent(.038),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _utils.getHeightPercent(.06)),
            Material(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.location_searching),
                title: Text('Ubicación Actual'),
                // subtitle: Text(_locationCtrl.currentStreet.value),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                onTap: () {
                  Get.back();
                  Dialogs.instance.showMapBottomSheet();
                },
              ),
            ),
            Divider(height: 1, color: kPrimaryColor),
            Expanded(
              child: _locationCtrl.addressesList.length == 0
                  ? Center()
                  : Material(
                      color: Colors.white,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemCount: _locationCtrl.addressesList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          final place =
                              _locationCtrl.addressesList[index].results![0];
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            key: Key(place.placeId!),
                            background: Container(),
                            dismissThresholds: {
                              DismissDirection.endToStart: 0.4
                            },
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    Icon(Icons.delete, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              _locationCtrl.addressesList
                                  .remove(_locationCtrl.addressesList[index]);

                              SharedPrefs.instance.setKey(
                                'addresses',
                                json.encode(_locationCtrl.addressesList),
                              );
                            },
                            confirmDismiss: (direction) async {
                              final delete =
                                  await Dialogs.instance.showLottieDialog(
                                title:
                                    '¿Estás seguro de eliminar esta dirección?',
                                lottieSrc: 'assets/animations/delete.json',
                                firstButtonText: 'Eliminar',
                                secondButtonText: 'Cancelar',
                                firstButtonBgColor: Colors.red,
                                secondButtonBgColor: Colors.transparent,
                                firstButtonTextColor: Colors.white,
                                secondButtonTextColor: Colors.black54,
                              );
                              return delete;
                            },
                            child: ListTile(
                              leading: Icon(Icons.location_on_outlined),
                              // tileColor: Colors.red,
                              title: Text('${place.formattedAddress}'),
                              trailing: Icon(Icons.arrow_forward_ios_outlined),
                              onTap: () {
                                print(place.formattedAddress);
                                _locationCtrl.tempAddress.value =
                                    _locationCtrl.addressesList[index];
                                _miscCtrl.updateDeliveryPrice();

                                Get.back();
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, int index) => Divider(
                          height: 1,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
