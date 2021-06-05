import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

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
  List deliveryTimes = [];
  String deliveryTimeText = '';

  void getCurrentTime() async {
    deliveryHours = await TrafficService.instance.getDeliveryTimes();

    deliveryHoursTemp = deliveryHours;
    final time = await TrafficService.instance.getCurrentTime();

    print('time $time');
    print('deliveryHours ${DateTime.parse(deliveryHours[1][0])}');
    print('after ${time.isAfter(DateTime.parse(deliveryHours[1][0]))}');

    if (time.isAfter(DateTime.parse(deliveryHours[1][0]))) {
      print('YA NO HAY====');
      _miscCtrl.isOpen.value = false;
      await Dialogs.instance.showLottieDialog(
        title:
            'El horario de venta terminó, recibiremos pedidos mañana a partir de las 11:00 A.M.',
        lottieSrc: 'assets/animations/time.json',
        firstButtonText: 'Ok',
        secondButtonText: '',
        firstButtonBgColor: kPrimaryColor,
        firstButtonTextColor: kSecondaryColor,
        secondButtonBgColor: kPrimaryColor,
        secondButtonTextColor: kSecondaryColor,
      );
      Get.back();
      return;
    } else {
      _miscCtrl.isOpen.value = true;
    }

    if (time.isAfter(DateTime.parse(deliveryHours[0][0]))) {
      print('isAfter ');
      deliveryHoursTemp = deliveryHours[1];

      deliveryTimes.add(deliveryHours[1]);
    } else {
      deliveryHoursTemp = deliveryHours[0];
      deliveryTimes.add(deliveryHours[0]);
      deliveryTimes.add(deliveryHours[1]);
    }
    print('deliveryHoursTemp ${deliveryHours.length}');

    _miscCtrl.deliveryHour.value =
        'Entre ${DateFormat('hh:mm a').format(DateTime.parse(deliveryTimes[_miscCtrl.isRadioSelected.value][1]))} y ${DateFormat('hh:mm a').format(DateTime.parse(deliveryTimes[_miscCtrl.isRadioSelected.value][2]))}';

    setState(() {});
  }

  @override
  void initState() {
    _miscCtrl.isOpen.value = false;
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
                  deliveryTimes.length == 0
                      ? 'No disponible'
                      : 'Entre ${DateFormat('hh:mm a').format(DateTime.parse(deliveryTimes[_miscCtrl.isRadioSelected.value][1]))} y ${DateFormat('hh:mm a').format(DateTime.parse(deliveryTimes[_miscCtrl.isRadioSelected.value][2]))}',
                  style: TextStyle(
                    fontSize: _utils.getHeightPercent(.02),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: deliveryTimes.length == 0
                  ? null
                  : () {
                      Get.defaultDialog(
                        title: 'Selecciona un horario de entrega',
                        content: Container(
                          height: deliveryTimes.length * 50,
                          width: _utils.getWidthPercent(.9),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: deliveryTimes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = deliveryTimes[index];
                              return Obx(
                                () => LabeledRadio(
                                  label:
                                      'Entre ${DateFormat('hh:mm a').format(DateTime.parse(item[1]))} y ${DateFormat('hh:mm a').format(DateTime.parse(item[2]))}',
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  value: index,
                                  groupValue: _miscCtrl.isRadioSelected.value,
                                  onChanged: (dynamic newValue) {
                                    setState(() {
                                      _miscCtrl.isRadioSelected.value =
                                          newValue!;
                                    });
                                  },
                                  deliveryTimes: deliveryTimes,
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
  LabeledRadio({
    Key? key,
    required this.label,
    required this.padding,
    required this.groupValue,
    required this.value,
    required this.onChanged,
    required this.deliveryTimes,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final dynamic groupValue;
  final dynamic value;
  final Function onChanged;
  final List deliveryTimes;

  final _miscCtrl = Get.find<MiscController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
        print('VALUE $value');
        if (value != groupValue) {
          onChanged(value);
        }

        _miscCtrl.deliveryHour.value =
            'Entre ${DateFormat('hh:mm a').format(DateTime.parse(deliveryTimes[_miscCtrl.isRadioSelected.value][1]))} y ${DateFormat('hh:mm a').format(DateTime.parse(deliveryTimes[_miscCtrl.isRadioSelected.value][2]))}';
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
