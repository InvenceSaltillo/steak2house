import 'dart:convert';

import 'package:conekta_flutter/conekta_card.dart';
import 'package:conekta_flutter/conekta_flutter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/cart_model.dart';
import 'package:steak2house/src/models/conekta/payment_sources_model.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';

import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class PaymentService {
  PaymentService._internal();
  static PaymentService _instance = PaymentService._internal();
  static PaymentService get instance => _instance;

  final dio.Dio _dio = dio.Dio();

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String urlEndpoint = '${Utils.instance.urlBackend}';

  final _userCtrl = Get.find<UserController>();
  final _paymentCtrl = Get.find<PaymentController>();
  final _cartCtrl = Get.find<CartController>();
  final _miscCtrl = Get.find<MiscController>();

  final conekta = ConektaFlutter();

  Future<bool> createCustomer(String token) async {
    Dialogs.instance.showLoadingProgress(message: 'Espere un momento');

    final _user = _userCtrl.user.value;

    dio.FormData _data = dio.FormData.fromMap({
      'userId': _user.id,
      'name': _user.name,
      'email': _user.email,
      'phone': '8448806948',
      'type': 'card',
      'token_id': token,
      // 'token_id': token,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}payment/createCustomer',
        data: _data,
        options: dio.Options(headers: headers),
      );

      print('createCustomer ${response.data['data']['id']}');

      final String conektaId = response.data['data']['id'];

      _userCtrl.user.value.conektaCustomerId = conektaId;

      await SharedPrefs.instance.setKey(
        'user',
        json.encode(_userCtrl.user.value),
      );

      print('TARJETA ${response.data['data']['payment_sources']['data']['0']}');
      final newCardData = response.data['data']['payment_sources']['data']['0'];

      final newCard = ConecktaPaymentSource.fromJson(newCardData);
      print('NEWCARD ${newCard.last4}');

      _paymentCtrl.cardsList.add(newCard);
      _paymentCtrl.lastUsedCard.value = newCard;

      await SharedPrefs.instance.setKey(
        'cardList',
        json.encode(_paymentCtrl.cardsList),
      );

      await SharedPrefs.instance.setKey(
        'lastUsedCard',
        json.encode(_paymentCtrl.lastUsedCard.value),
      );

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

  Future<bool> createCharge() async {
    Dialogs.instance.showLoadingProgress(message: 'Espere un momento');

    final deliveryPrice = _miscCtrl.deliveryDistance.value < 5
        ? 50
        : (_miscCtrl.deliveryDistance.value * _miscCtrl.priceKM.value).ceil();

    final _user = _userCtrl.user.value;

    final deliveryItem = {
      'name': 'Envío',
      'unit_price': '${deliveryPrice.toString()}00',
      'quantity': 1
    };

    dio.FormData _data = dio.FormData.fromMap({
      'userId': _user.id,
      'customerId': _user.conektaCustomerId,
      'items': json.encode(_cartCtrl.cartList),
      'paymentSourceId': _paymentCtrl.lastUsedCard.value.id,
      'deliveryItem': json.encode(deliveryItem),
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}payment/createCharge',
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

  Future<bool> createPaymentSource(String token) async {
    Dialogs.instance.showLoadingProgress(message: 'Validando información');

    final _user = _userCtrl.user.value;

    dio.FormData _data = dio.FormData.fromMap({
      'customerId': _user.conektaCustomerId,
      'type': 'card',
      'tokenId': token,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}payment/createPaymentSource',
        data: _data,
        options: dio.Options(headers: headers),
      );

      print('createPaymentSource ${response.data['data']}');

      final newCardData = response.data['data'];

      final newCard = ConecktaPaymentSource.fromJson(newCardData);
      print('NEWCARD ${newCard.last4}');

      _paymentCtrl.cardsList.add(newCard);
      _paymentCtrl.lastUsedCard.value = newCard;

      await SharedPrefs.instance.setKey(
        'cardList',
        json.encode(_paymentCtrl.cardsList),
      );

      await SharedPrefs.instance.setKey(
        'lastUsedCard',
        json.encode(_paymentCtrl.lastUsedCard.value),
      );

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

  Future<String> createCardToken(ConektaCard card) async {
    Dialogs.instance.showLoadingProgress(message: 'Espere un momento');
    try {
      final cardToken = await conekta.createCardToken(card);
      Get.back();
      return cardToken;
    } on PlatformException catch (exception) {
      print('Exception $exception');
      return '';
    }
  }
}
