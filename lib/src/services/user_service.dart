import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user/my_orders_model.dart';
import 'package:steak2house/src/utils/secure_storage.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class UserService {
  UserService._internal();
  static UserService _instance = UserService._internal();
  static UserService get instance => _instance;

  final dio.Dio _dio = dio.Dio();

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String urlEndpoint = '${Utils.instance.urlBackend}users/';
  final _userCtrl = Get.find<UserController>();

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
        '${urlEndpoint}getOrders',
        data: _data,
        options: dio.Options(headers: headers),
      );

      final ordersListTemp = response.data['data'] as List;
      final List<MyOrders> myOrdersList =
          ordersListTemp.map((item) => new MyOrders.fromJson(item)).toList();
      _userCtrl.ordersList.value = myOrdersList;
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
}
