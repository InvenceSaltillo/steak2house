import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import 'package:steak2house/src/controllers/product_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/utils/debouncer.dart';
import 'package:steak2house/src/utils/secure_storage.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class ProductService {
  ProductService._internal();
  static ProductService _instance = ProductService._internal();
  static ProductService get instance => _instance;

  final debouncer = Debouncer<String>(duration: Duration(milliseconds: 500));
  final StreamController<List<Product>> _searchStreamController =
      StreamController<List<Product>>.broadcast();
  Stream<List<Product>> get searchStream => this._searchStreamController.stream;

  final dio.Dio _dio = dio.Dio();

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String urlEndpoint = '${Utils.instance.urlBackend}products/';
  final productCtrl = Get.find<ProductController>();
  final _userCtrl = Get.find<UserController>();

  Future<List<Product>> searchProducts(String query) async {
    final token = await SecureStorage.instance.readItem('token');

    try {
      final response = await _dio.get(urlEndpoint, queryParameters: {
        'token': token,
        'query': query,
      });

      if (response.data['data'].length == 0) {
        // Dialogs.instance.dismiss();
        productCtrl.loading.value = false;
        // productCtrl.searchResult.value = [];
        return [];
      } else {
        List productsList = response.data['data'] as List;
        final products = productsList
            .map((product) => new Product.fromJson(product))
            .toList();

        // productCtrl.searchResult.value = products;

        productCtrl.loading.value = false;

        // Dialogs.instance.dismiss();
        return products;
      }
    } on dio.DioError catch (e) {
      print('ErrorSEARCH $e');
      return [];
    }
  }

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

  Future<bool> getOrders() async {
    Dialogs.instance.showLoadingProgress(message: 'Espere un momento');

    final _user = _userCtrl.user.value;
    final token = await SecureStorage.instance.readItem('token');

    dio.FormData _data = dio.FormData.fromMap({
      'userId': _user.id,
      'token': token,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}users/getOrders',
        data: _data,
        options: dio.Options(headers: headers),
      );

      print('createCharge ${response.data}');

      // final items =
      Get.back();

      return true;
    } on dio.DioError catch (e) {
      Get.back();
      if (e.response != null) {
        print('DIOERROR DATA===== ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');

        final String message = e.response!.data['data'];

        Dialogs.instance.showSnackBar(
          DialogType.error,
          message,
          false,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return false;
    }
  }

  Future<int> getKMPrice() async {
    try {
      final response = await _dio.get(
        '${Utils.instance.urlBackend}delivery/deliveryPrice',
        options: dio.Options(headers: headers),
      );

      return response.data['data'];
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA===== ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
      }
      return 0;
    }
  }

  void getSearchByQuery(String busqueda) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final resultados = await this.searchProducts(value);
      this._searchStreamController.add(resultados);
    };

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      debouncer.value = busqueda;
    });

    Future.delayed(Duration(milliseconds: 201)).then((_) => timer.cancel());
  }
}
