import 'dart:convert';

import 'package:conekta_flutter/conekta_card.dart';
import 'package:conekta_flutter/conekta_flutter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/controllers/cart_controller.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/payment_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/cart_model.dart';
import 'package:steak2house/src/models/conekta/client_model.dart';
import 'package:steak2house/src/models/conekta/payment_sources_model.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/utils/secure_storage.dart';
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

  Future<ConecktaClient> getConektaCustomer() async {
    // Dialogs.instance.showLoadingProgress(message: 'Espere un momento...');

    final token = await SecureStorage.instance.readItem('token');

    try {
      final response =
          await _dio.get('${urlEndpoint}payment', queryParameters: {
        'customerId': _userCtrl.user.value.conektaCustomerId,
        'token': token,
      });

      ConecktaClient.fromJson(response.data['data']);

      if (response.data['data']['paymentSources'] != null) {
        final paymentSource = response.data['data']['paymentSources'] as List;

        final List<ConecktaPaymentSource> myCardList = paymentSource
            .map((item) => new ConecktaPaymentSource.fromJson(item))
            .toList();

        _paymentCtrl.cardsList.value = [];

        _paymentCtrl.cardsList.value = myCardList;

        if (_paymentCtrl.lastUsedCard.value.last4 == null) {
          _paymentCtrl.lastUsedCard.value = _paymentCtrl.cardsList[0];
        }

        print('lastUsedCard ${_paymentCtrl.lastUsedCard.value.last4}');
      }

      // Get.back();
      return ConecktaClient();
    } on dio.DioError catch (e) {
      // Get.back();
      if (e.response != null) {
        print('DIOERROR getConektaCustomer DATA===== ${e.response!.data}');
        print(
            'DIOERROR getConektaCustomer HEADERS===== ${e.response!.headers}');

        final String message = e.response!.data['data'];

        Dialogs.instance.showSnackBar(
          DialogType.error,
          message,
          false,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR getConektaCustomer MESSAGE===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return ConecktaClient();
    }
  }

  Future<bool> deletePaymentSource(String paymentSourceId) async {
    final token = await SecureStorage.instance.readItem('token');

    Dialogs.instance.showLoadingProgress(message: 'Espere un momento...');

    final _user = _userCtrl.user.value;

    dio.FormData _data = dio.FormData.fromMap({
      'conektaCustomerId': _user.conektaCustomerId,
      'paymentSourceId': paymentSourceId,
      'token': token,
    });
    try {
      final response = await _dio.post(
        '${urlEndpoint}payment/deletePaymentSource',
        data: _data,
        options: dio.Options(headers: headers),
      );

      print('deletePaymentSource ${response.data['data']}');

      SharedPrefs.instance.setKey(
        'cardList',
        json.encode(_paymentCtrl.cardsList),
      );

      Get.back();
      return true;
    } on dio.DioError catch (e) {
      Get.back();
      if (e.response != null) {
        print('DIOERROR deletePaymentSource DATA===== ${e.response}');
        print(
            'DIOERROR deletePaymentSource HEADERS===== ${e.response!.headers}');

        final String message = e.response!.data;

        Dialogs.instance.showSnackBar(
          DialogType.error,
          message,
          false,
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR deletePaymentSource MESSAGE===== ${e.message}');
        Dialogs.instance.showSnackBar(
          DialogType.error,
          e.message,
          false,
        );
      }
      return false;
    }
  }

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

      print('createCustomer ${response.data['data']}');

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

        Dialogs.instance.showLottieDialog(
          title: message,
          lottieSrc: 'assets/animations/error.json',
          lottieSize: .25,
          firstButtonText: '',
          secondButtonText: '',
          firstButtonBgColor: kPrimaryColor,
          firstButtonTextColor: kSecondaryColor,
          secondButtonBgColor: kPrimaryColor,
          secondButtonTextColor: kSecondaryColor,
        );

        await Future.delayed(Duration(seconds: 5));
        Get.back();

        // Dialogs.instance.showSnackBar(
        //   DialogType.error,
        //   message,
        //   false,
        // );
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
      Get.back();
      Dialogs.instance.showSnackBar(
        DialogType.error,
        '${exception.message}',
        false,
      );
      print('Exception ${exception.message}');
      return '';
    }
  }
}
