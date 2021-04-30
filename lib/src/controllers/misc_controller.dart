import 'package:get/get.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class MiscController extends GetxController {
  var errorMessage = ''.obs;

  void showWelcomeDialog() {
    Dialogs.instance.showSnackBar(
      DialogType.success,
      'Que gusto verte de nuevo ',
    );
  }

  void showErrorServerSnackBar() {
    Dialogs.instance.showSnackBar(DialogType.error, errorMessage.value);
  }
}
