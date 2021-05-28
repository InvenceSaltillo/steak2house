import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class DeliveryTimeCard extends StatefulWidget {
  DeliveryTimeCard({
    Key? key,
  }) : super(key: key);

  @override
  _DeliveryTimeCardState createState() => _DeliveryTimeCardState();
}

class _DeliveryTimeCardState extends State<DeliveryTimeCard> {
  final _miscCtrl = Get.find<MiscController>();

  final _utils = Utils.instance;
  List deliveryHours = [];
  List deliveryHoursTemp = [];

  void getCurrentTime() async {
    deliveryHours = await TrafficService.instance.getDeliveryTimes();

    deliveryHoursTemp = deliveryHours;
    final time = await TrafficService.instance.getCurrentTime();

    setState(() {
      deliveryHoursTemp
          .removeWhere((element) => time.isAfter(DateTime.parse(element)));
    });
  }

  @override
  void initState() {
    getCurrentTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(FontAwesomeIcons.clock, color: kPrimaryColor),
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
                  deliveryHoursTemp.length == 0
                      ? 'No disponible'
                      : '${DateFormat('hh:mm a').format(DateTime.parse(deliveryHoursTemp[_miscCtrl.isRadioSelected.value]))}',
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
                  content: Container(
                    height: deliveryHours.length * 50,
                    width: _utils.getWidthPercent(.9),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: deliveryHoursTemp.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = deliveryHoursTemp[index];
                        return Obx(
                          () => LabeledRadio(
                            label:
                                '${DateFormat('hh:mm a').format(DateTime.parse(item))}',
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            value: index,
                            groupValue: _miscCtrl.isRadioSelected.value,
                            onChanged: (dynamic newValue) {
                              setState(() {
                                _miscCtrl.isRadioSelected.value = newValue!;
                              });
                            },
                          ),
                        );
                      },
                    ),
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
  final dynamic groupValue;
  final dynamic value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
        print(value);
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio(
              fillColor:
                  MaterialStateColor.resolveWith((states) => kPrimaryColor),
              groupValue: groupValue,
              value: value,
              onChanged: (dynamic? newValue) {
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
