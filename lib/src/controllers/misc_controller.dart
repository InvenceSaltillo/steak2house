import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:steak2house/src/services/products_service.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import '../constants.dart';
import 'cart_controller.dart';

class MiscController extends GetxController {
  var errorMessage = ''.obs;
  var snackBarStatus = SnackbarStatus.CLOSED.obs;
  var snackBar = false.obs;
  var showAppBar = true.obs;
  var isRadioSelected = 0.obs;

  var deliveryHour = ''.obs;

  var deliveryDistance = 0.0.obs;

  var calculateDistance = false.obs;

  var priceKM = 0.obs;

  var totalPriceDelivery = 0.0.obs;
  var isOpen = false.obs;
  var isOpenFlag = true.obs;

  void showWelcomeDialog() {
    Dialogs.instance.showSnackBar(
      DialogType.success,
      'Que gusto verte de nuevo ',
      false,
    );
  }

  void showErrorServerSnackBar() {
    Dialogs.instance.showSnackBar(DialogType.error, errorMessage.value, false);
  }

  Future<void> timeIsOut() async {
    final deliveryHours = await TrafficService.instance.getDeliveryTimes();

    final time = await TrafficService.instance.getCurrentTime();

    final lastHour = DateTime.parse(deliveryHours[deliveryHours.length - 1]);

    final difference = lastHour.difference(time).inMinutes;

    print('DIFF=====$difference');

    if (difference <= 20 && difference > 0) {
      print(
          'El horario de venta está por terminar, te invitamos a que realices tu pedido antes de las ${DateFormat('hh:mm a').format(lastHour)}');

      Dialogs.instance.showLottieDialog(
        title:
            'El horario de venta está por terminar, te invitamos a que realices tu pedido antes de las ${DateFormat('hh:mm a').format(lastHour)}',
        lottieSrc: 'assets/animations/time.json',
        firstButtonText: 'Ok',
        secondButtonText: '',
        firstButtonBgColor: kPrimaryColor,
        firstButtonTextColor: kSecondaryColor,
        secondButtonBgColor: kPrimaryColor,
        secondButtonTextColor: kSecondaryColor,
      );
    }

    if (time.isAfter(lastHour) || difference == 0) {
      isOpen.value = false;
      print(
          'El horario de venta terminó, recibiremos pedidos mañana a partir de las 11:00 A.M.');

      Dialogs.instance.showLottieDialog(
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
    }
  }

  void updateDeliveryPrice() async {
    final _cartCtrl = Get.find<CartController>();
    calculateDistance.value = true;
    deliveryDistance.value = 0.0;
    deliveryDistance.value =
        await TrafficService.instance.getDeliveryDistance();
    if (deliveryDistance.value < 5) {
      totalPriceDelivery.value = 50;
      totalPriceDelivery.value =
          totalPriceDelivery.value + _cartCtrl.totalCart.value;
    } else {
      totalPriceDelivery.value = ((deliveryDistance.value * priceKM.value) +
          _cartCtrl.totalCart.value);
    }
    calculateDistance.value = false;
  }

  @override
  void onReady() async {
    priceKM.value = await ProductService.instance.getKMPrice();
    super.onReady();
  }
}
