import 'package:get/get.dart';
import 'package:steak2house/src/services/products_service.dart';
import 'package:steak2house/src/services/traffic_service.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

import 'cart_controller.dart';

class MiscController extends GetxController {
  final _cartCtrl = Get.find<CartController>();
  var errorMessage = ''.obs;
  var snackBarStatus = SnackbarStatus.CLOSED.obs;
  var snackBar = false.obs;
  var showAppBar = true.obs;

  var deliveryDistance = 0.0.obs;

  var calculateDistance = false.obs;

  var priceKM = 0.obs;

  var totalPriceDelivery = 0.0.obs;

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

  void updateDeliveryPrice() async {
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
