import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/location_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';

import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user/my_orders_model.dart';
import 'package:steak2house/src/models/user/user_model.dart';
import 'package:steak2house/src/utils/secure_storage.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
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
  final _miscCtrl = Get.find<MiscController>();
  final _cartCtrl = Get.find<CartController>();
  final _locationCtrl = Get.find<LocationController>();

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

  Future<bool> updatePhoneNumber(String phoneNumber) async {
    Dialogs.instance.showLoadingProgress(message: 'Espere un momento');

    final _user = _userCtrl.user.value;

    dio.FormData _data = dio.FormData.fromMap({
      'userId': _user.id,
      'phoneNumber': phoneNumber,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}updatePhoneNumber',
        data: _data,
        options: dio.Options(headers: headers),
      );

      final userInfo = response.data['data'];

      final user = User.fromJson(userInfo);

      await SharedPrefs.instance.setKey('user', json.encode(user));
      Get.back();

      return true;
    } on dio.DioError catch (e) {
      Get.back();
      if (e.response != null) {
        print('DIOERROR DATA updatePhoneNumber===== ${e.response!.data}');
        print('DIOERROR HEADERS updatePhoneNumber===== ${e.response!.headers}');

        final String message = e.response!.data['data'];

        Dialogs.instance.showSnackBar(
          DialogType.error,
          message,
          false,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE updatePhoneNumber===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return false;
    }
  }

  Future<bool> sendTelegramMessage() async {
    // Dialogs.instance.showLoadingProgress(message: 'Espere un momento');

    final String coords =
        '${_locationCtrl.tempAddress.value.results![0].geometry!.location!.lat!},${_locationCtrl.tempAddress.value.results![0].geometry!.location!.lng!}';
    final address =
        _locationCtrl.tempAddress.value.results![0].formattedAddress;
    var itemsString = '';
    for (var item in _cartCtrl.cartList) {
      itemsString += '${item.qty!} x ${item.product!.name!}\n';
    }

    var message = 'Pedido a nombre de:\n';
    message += '${_userCtrl.user.value.name}\n\n';
    message += 'Dirección:\n$address\n';
    message += '\nTeléfono:\n${_userCtrl.user.value.tel}\n\n';
    message += 'Productos:\n';
    message += '$itemsString\n';
    message += 'Subtotal:\n';
    message += '\$${_cartCtrl.totalCart}\n';
    message += 'Envío:\n';
    message += _miscCtrl.deliveryDistance < 5
        ? '\$50'
        : '\$${(_miscCtrl.deliveryDistance.value * _miscCtrl.priceKM.value).ceil()}';
    message += '\nTotal:\n';
    message += ' \$${_miscCtrl.totalPriceDelivery.ceil()}\n\n';
    message += 'Ubicación\n';
    message +=
        'https://www.google.com.mx/maps/dir/25.4116308,-100.9936945/$coords/@$coords,15z\n';

    dio.FormData _data = dio.FormData.fromMap({
      'text': message,
      'chat_id': '-1001284440084',
    });

    try {
      final response = await _dio.post(
        'https://api.telegram.org/bot1862254326:AAFuDSFArPjmQFGAPGKQvTqC2Q5sh8SeXP0/sendMessage',
        data: _data,
        options: dio.Options(headers: headers),
      );

      print('RESPONSE ${response.data}');

      // final userInfo = response.data['data'];

      // final user = User.fromJson(userInfo);

      // await SharedPrefs.instance.setKey('user', json.encode(user));
      // Get.back();

      return true;
    } on dio.DioError catch (e) {
      Get.back();
      if (e.response != null) {
        print('DIOERROR DATA updatePhoneNumber===== ${e.response!.data}');
        print('DIOERROR HEADERS updatePhoneNumber===== ${e.response!.headers}');

        final String message = e.response!.data['data'];

        Dialogs.instance.showSnackBar(
          DialogType.error,
          message,
          false,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE updatePhoneNumber===== ${e.message}');
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
