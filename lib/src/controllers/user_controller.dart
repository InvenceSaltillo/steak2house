import 'package:get/get.dart';
import 'package:steak2house/src/models/user_model.dart';

class UserController extends GetxController {
  var user = User().obs;
  var loading = true.obs;
  var token = ''.obs;
}
