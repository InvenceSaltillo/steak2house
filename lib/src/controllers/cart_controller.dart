import 'package:get/get.dart';
import 'package:steak2house/src/models/cart_model.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';

class CartController extends GetxController {
  RxList<Cart> cartList = RxList<Cart>();
  var totalCart = 0.obs;

  void updateTotal() {
    cartList.forEach((element) {
      totalCart += int.parse(element.product!.price!) * element.qty!;
    });
  }

  Future<void> getCartList() async {
    try {
      final cartListTemp =
          await SharedPrefs.instance.getKey('cartList') as List;

      final List<Cart> myCartList =
          cartListTemp.map((item) => new Cart.fromJson(item)).toList();
      cartList.value = myCartList;
    } catch (e) {
      print('ERRORRRR=========');
    }
  }

  @override
  void onReady() async {
    await getCartList();
    super.onReady();
  }
}
