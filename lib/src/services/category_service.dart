import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/categories_controller.dart';

import 'package:steak2house/src/models/category_model.dart';
import 'package:steak2house/src/utils/utils.dart';

class CategoryService {
  CategoryService._internal();
  static CategoryService _instance = CategoryService._internal();
  static CategoryService get instance => _instance;

  final dio.Dio _dio = dio.Dio();

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String urlEndpoint = '${Utils.instance.urlBackend}';

  Future<List<Category>> getCategories() async {
    final categorieCtrl = Get.find<CategoriesController>();
    try {
      final response = await _dio.get(
        '${urlEndpoint}categories',
      );

      List catResponse = response.data['data'] as List;
      final categoriesList = catResponse
          .map((category) => new Category.fromJson(category))
          .toList();

      await Future.delayed(Duration(seconds: 2));
      categorieCtrl.categories.value = categoriesList;
      categorieCtrl.loading.value = false;

      return categoriesList;
    } catch (e) {
      // Dialogs.instance.dismiss();
      categorieCtrl.loading.value = false;
      return [];
    }
  }

  Future<List<Category>> getCategoryById(String id) async {
    final categorieCtrl = Get.find<CategoriesController>();
    try {
      final response = await _dio.get(
        '${urlEndpoint}categories',
      );

      List catResponse = response.data['data'] as List;
      final categoriesList = catResponse
          .map((category) => new Category.fromJson(category))
          .toList();

      await Future.delayed(Duration(seconds: 2));
      categorieCtrl.categories.value = categoriesList;
      categorieCtrl.loading.value = false;

      print('CATEGORIAS BY ID======= ${categorieCtrl.categories}');
      return categoriesList;
    } catch (e) {
      // Dialogs.instance.dismiss();
      categorieCtrl.loading.value = false;
      return [];
    }
  }
}
