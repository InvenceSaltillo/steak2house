import 'package:get/get.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';

class ProductController extends GetxController {
  RxList<Product> products = RxList<Product>();
  RxList<Product> favoriteList = RxList<Product>();

  var productQty = 1.obs;
  var productTotal = 0.0.obs;
  late var currentProduct = Product().obs;

  var loading = false.obs;

  var isLiked = false.obs;

  var fromFavorites = false.obs;

  Future<void> getFavoriteList() async {
    try {
      final favoriteListTemp =
          await SharedPrefs.instance.getKey('favoriteList') as List;

      final List<Product> myFavoriteList =
          favoriteListTemp.map((item) => new Product.fromJson(item)).toList();
      favoriteList.value = myFavoriteList;
    } catch (e) {
      print('ERRORRRR========= myFavoriteList');
    }
  }

  void increment() {
    productQty.value++;
    updateProductTotal();
  }

  void decrement() {
    productQty.value--;
    updateProductTotal();
  }

  void updateProductTotal() {
    productTotal.value =
        double.parse(currentProduct.value.price!) * productQty.value;
  }

  void resetNumbers() {
    currentProduct.value.price = '1';
    productQty.value = 1;
    productTotal.value = 0;
  }

  @override
  void onReady() {
    getFavoriteList();
    super.onReady();
  }
}
