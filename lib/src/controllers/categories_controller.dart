import 'package:get/get.dart';
import 'package:steak2house/src/models/category_model.dart';

class CategoriesController extends GetxController {
  var currentIndex = 0.obs;
  var loading = true.obs;
  RxList<Category> categories = RxList<Category>();
}
