import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user/user_model.dart';

import 'package:flutter/material.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/screens/sign_in/sign_in_screen.dart';
import 'package:steak2house/src/utils/secure_storage.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class AuthService {
  AuthService._internal();
  static AuthService _instance = AuthService._internal();
  static AuthService get auth => _instance;

  final _userCtrl = Get.find<UserController>();
  final _miscCtrl = Get.find<MiscController>();

  final dio.Dio _dio = dio.Dio();

  Completer _completer = Completer();

  Map<String, String> headers = {
    'Content-Type': 'application/json;charset=UTF-8',
    'Charset': 'utf-8'
  };

  final String urlEndpoint = '${Utils.instance.urlBackend}users/';

  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  void _complete() {
    if (_completer != null && !_completer.isCompleted) {
      _completer.complete();
    }
  }

  // Future<void> googleLogin() async {
  //   try {
  //     final account = await _googleSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<bool> appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print('AuthCode ${credential.authorizationCode}');
    print('userIdentifier ${credential.userIdentifier}');
    print('identityToken ${credential.identityToken}');
    return true;
  }

  Future<bool> isLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      // Esta loggeado con facebook

      final user = await SharedPrefs.instance.getKey('user');

      final userInfo = User.fromJson(user!);

      print('FACEBOOK LOGGED!!! ${userInfo.id}');

      return await getUserInfo(userInfo.id!);
    } else {
      print('NOT LOGGED!!!');
      return false;
    }
  }

  Future facebookLogin() async {
    Dialogs.instance.showLoadingProgress(
      message: 'Espere un momento...',
    );

    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData();
      dio.FormData _data = dio.FormData.fromMap({
        'userData': userData,
        "token": result.accessToken?.token,
      });

      try {
        final response = await _dio.post(
          '${urlEndpoint}login',
          data: _data,
          options: dio.Options(headers: headers),
        );

        if (response.data['data'] != null) {
          print('REGISTER======');
          // print('RESPONSE DATA ${response.data['data']['user']}');
          final user = User.fromJson(response.data['data']['user']);
          await SharedPrefs.instance.setKey('user', json.encode(user));
          await SharedPrefs.instance
              .setKey('createdAt', DateTime.now().toString());

          _userCtrl.user.value = user;
          Dialogs.instance.dismiss();

          Dialogs.instance.showSnackBar(
            DialogType.success,
            'Bienvenido ${user.name}',
            false,
          );

          Get.offUntil(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return MainScreen();
              },
              transitionDuration: Duration(milliseconds: 800),
            ),
            (route) => false,
          );

          Dialogs.instance.showPhoneDialog();
        } else {
          print('LOGIN======== ${response.data['token']}');
          final user = User.fromJson(response.data['user']);
          final token = response.data['token'];

          Dialogs.instance.showSnackBar(
            DialogType.success,
            '¡Qué gusto verte de nuevo ${user.name}!',
            false,
          );

          _userCtrl.user.value = user;
          await SharedPrefs.instance.setKey('user', json.encode(user));
          await SecureStorage.instance.addNewItem(token, 'token');
          await SharedPrefs.instance
              .setKey('createdAt', DateTime.now().toString());
          await Future.delayed(Duration(seconds: 3));
          Get.offUntil(
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return MainScreen();
              },
              transitionDuration: Duration(milliseconds: 800),
            ),
            (route) => false,
          );
        }
      } on dio.DioError catch (e) {
        if (e.response != null) {
          print('DIOERROR DATA===== ${e.response!.data}');
          print('DIOERROR HEADERS===== ${e.response!.headers}');
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print(
              'DIOERROR MESSAGE facebookLogin===== ${e}, ${Utils.instance.urlBackend}');
          Get.back();
          Dialogs.instance.showSnackBar(
            DialogType.error,
            'No se pudo conectar al servidor, intentalo de nuevo más tarde!',
            false,
          );
        }
      }
    } else {
      Dialogs.instance.dismiss();
      Dialogs.instance.showSnackBar(
        DialogType.error,
        'Se canceló el inicio de sesión',
        false,
      );
      print(result.status);
      print(result.message);
    }
  }

  Future<String> getAccessToken() async {
    // ignore: unnecessary_null_comparison
    if (_completer != null) {
      _completer.future;
    }
    _completer = Completer();

    final token = await SecureStorage.instance.readItem('token');

    print('TOKENSTORAGE $token');

    if (token != null) {
      final DateTime currentDate = DateTime.now();

      final int expiresIn = 3600;
      final createdAtStr = await SharedPrefs.instance.getCreatedAt();
      final createdAt = DateTime.parse(createdAtStr);

      final int diff = currentDate.difference(createdAt).inSeconds;

      print('SESSION LIFE TIME ${expiresIn - diff}');

      if (expiresIn - diff >= 60) {
        _complete();
        return token;
      }

      print('Refresh TOKEN ');
      await refreshToken(token);
      _complete();

      // if(tokenRefreshResponse){}
      return token;
    }

    _complete();
    return '';
  }

  Future<bool> refreshToken(String expiredToken) async {
    dio.FormData _data = dio.FormData.fromMap({
      "token": expiredToken,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}refreshToken',
        data: _data,
        options: dio.Options(headers: headers),
      );

      if (response.data['token'] != null) {
        print('NO HAY TOKEN');

        return false;
      } else {
        print('DATA==== ${response.data['data']}');
        final token = response.data['data']['token'];

        if (response.data['data']['userInfo'] != null) {
          final user = User.fromJson(response.data['data']['userInfo']);

          _userCtrl.user.value = user;

          // print('USER==== ${user.conektaCustomerId}');
          await SharedPrefs.instance.setKey('user', json.encode(user));
          await SecureStorage.instance.addNewItem(token, 'token');
        }
        return true;
      }
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA===== ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
        _miscCtrl.errorMessage.value =
            'No se pudo conectar al servidor, intentalo de nuevo más tarde!';
      }
      return false;
    }
  }

  Future getUserInfo(String userId) async {
    dio.FormData _data = dio.FormData.fromMap({
      "userId": userId,
    });

    try {
      final response = await _dio.post(
        '${urlEndpoint}getUserInfo',
        data: _data,
        options: dio.Options(headers: headers),
      );

      print('getUserInfo ${response.data['data']['token']}');

      if (response.data['data'] == null) {
        print('NO HAY DATA GETUSERINFO');

        return false;
      } else {
        if (response.data['data'] != null) {
          final user = User.fromJson(response.data['data']['userInfo']);
          final token = response.data['data']['token'];

          _userCtrl.user.value = user;

          print('ConektaID GETUSERINFO==== ${user.conektaCustomerId}');
          await SharedPrefs.instance.setKey('user', json.encode(user));

          await SecureStorage.instance.addNewItem(token, 'token');
          return true;
        }
      }
    } on dio.DioError catch (e) {
      if (e.response != null) {
        print('DIOERROR DATA ${e.response!.data}');
        print('DIOERROR HEADERS===== ${e.response!.headers}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('DIOERROR MESSAGE===== ${e.message}');
        _miscCtrl.errorMessage.value =
            'No se pudo conectar al servidor, intentalo de nuevo más tarde!';

        return false;
      }
    }
  }

  Future<void> logOut() async {
    await FacebookAuth.instance.logOut();

    await SharedPrefs.instance.clearPrefs();

    Get.offUntil(
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SignInScreen();
        },
        transitionDuration: Duration(milliseconds: 800),
      ),
      (route) => false,
    );
  }
}
