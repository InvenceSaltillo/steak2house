import 'package:get/get.dart';
import 'package:steak2house/src/models/user/my_orders_model.dart';
import 'package:steak2house/src/models/user/user_model.dart';

class UserController extends GetxController {
  var user = User().obs;
  var loading = true.obs;
  var token = ''.obs;
  var version = ''.obs;

  RxList<MyOrders> ordersList = RxList<MyOrders>();

  // Future<void> getOrdersList() async {
  //   try {
  //     final favoriteListTemp =
  //         await SharedPrefs.instance.getKey('favoriteList') as List;

  //   } catch (e) {
  //     print('No hay Favoritos========= myFavoriteList');
  //   }
  // }

  @override
  void onReady() {
    super.onReady();
  }
}
