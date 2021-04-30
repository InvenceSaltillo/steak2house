import 'package:get/get.dart';
import 'package:steak2house/src/models/product_model.dart';

class ProductController extends GetxController {
  RxList<Product> products = RxList<Product>();
  var productQty = 1.obs;
  var productTotal = 0.0.obs;
  late var currentProduct = Product().obs;
  var productLike = false.obs;

  var loading = false.obs;

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
}
