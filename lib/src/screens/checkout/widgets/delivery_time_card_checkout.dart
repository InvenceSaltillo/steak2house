import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../../../constants.dart';

class DeliveryTimeCard extends StatelessWidget {
  DeliveryTimeCard({
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
                    'Hora de entrega',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.015),
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '${_locationCtrl.tempAddress.value.results![0].formattedAddress!.split(',')[0]}',
                    style: TextStyle(
                      fontSize: _utils.getHeightPercent(.02),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                    title: 'Selecciona un horario de entrega',
                    content: Column(
                      children: [
                        LabeledRadio(
                          label: 'This is the first label text',
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          value: true,
                          groupValue: true,
                          onChanged: (bool newValue) {
                            // setState(() {
                            // _isRadioSelected = newValue;
                            // });
                          },
                        ),
                        LabeledRadio(
                          label: 'This is the first label text',
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          value: false,
                          groupValue: true,
                          onChanged: (bool newValue) {
                            // setState(() {
                            // _isRadioSelected = newValue;
                            // });
                          },
                        ),
                      ],
                    ),
                  );
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

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<bool>(
              groupValue: groupValue,
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
