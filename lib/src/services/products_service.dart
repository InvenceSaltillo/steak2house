import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/utils/utils.dart';

class ProductService {
  ProductService._internal();
  static ProductService _instance = ProductService._internal();
  static ProductService get instance => _instance;

  final dio.Dio _dio = dio.Dio();

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String urlEndpoint = '${Utils.instance.urlBackend}products/';
  final productCtrl = Get.find<ProductController>();

  Future<bool> getByCategory(String categoryId) async {
    // Dialogs.instance.showLoadingProgress(
    //   message: 'Espere un momento...',
    // );
    //
    productCtrl.loading.value = true;

    productCtrl.products.value = [];

    dio.FormData _data = dio.FormData.fromMap({
      "categoryId": categoryId,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}byCategory',
        data: _data,
        options: dio.Options(headers: headers),
      );

      // print('PRODUCTOS======== ${response.data['data'].length}');
      // await Future.delayed(Duration(seconds: 2));

      if (response.data['data'].length == 0) {
        // Dialogs.instance.dismiss();
        productCtrl.loading.value = false;
        return false;
      } else {
        List productsList = response.data['data'] as List;
        final products = productsList
            .map((product) => new Product.fromJson(product))
            .toList();

        productCtrl.products.value = products;

        productCtrl.loading.value = false;

        // Dialogs.instance.dismiss();
        return true;
      }
    } catch (e) {
      // Dialogs.instance.dismiss();
      productCtrl.loading.value = false;
      return false;
    }
  }
}
