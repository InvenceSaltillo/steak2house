import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../../constants.dart';

class ChekOutLocationCard extends StatelessWidget {
  ChekOutLocationCard({
    Key? key,
  }) : super(key: key);

  final _locationCtrl = Get.find<LocationController>();

  final _utils = Utils.instance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.delivery_dining, color: kPrimaryColor),
              SizedBox(width: _utils.getWidthPercent(.05)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dirección de entrega',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.015),
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    width: _utils.getWidthPercent(.6),
                    child: Text(
                      // '${_locationCtrl.tempAddress.value.results![0].formattedAddress!.split(',')[0]},${_locationCtrl.tempAddress.value.results![0].formattedAddress!.split(',')[0]},${_locationCtrl.tempAddress.value.results![0].formattedAddress!.split(',')[0]}',
                      '${_locationCtrl.tempAddress.value.results![0].formattedAddress!.split(',')[0]}',
                      style: TextStyle(
                        fontSize: _utils.getHeightPercent(.02),
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Dialogs.instance.showLocationBottomSheet();
                },
                child: Text(
                  'Cambiar',
                  style: TextStyle(
                    fontSize: _utils.getHeightPercent(.02),
                    color: kSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
