import 'package:dio/dio.dart' as dio;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:steak2house/src/controllers/misc_controller.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/models/user_model.dart';

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

  Future<void> googleLogin() async {
    try {
      final account = await _googleSignIn.signIn();
      print('Account $account');
    } catch (error) {
      print('Error en google signIn');
      print(error);
    }
  }

  Future checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;

    if (accessToken != null) {
      final userInfo = await getUserInfo();
      print('USERINFO!!! $userInfo');

      if (userInfo) {
        return true;
      } else {
        return false;
      }
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

          _userCtrl.user.value = user;
          Dialogs.instance.dismiss();

          Dialogs.instance.showSnackBar(
            DialogType.success,
            'Bienvenido ${user.name}',
          );
        } else {
          print('LOGIN======== ${response.data['token']}');
          final user = User.fromJson(response.data['user']);
          final token = response.data['token'];

          Dialogs.instance.showSnackBar(
            DialogType.success,
            '¡Qué gusto verte de nuevo ${user.name}!',
          );

          _userCtrl.user.value = user;
          await SharedPrefs.instance.setUserInfo(user);
          await SecureStorage.instance.addNewItem(token, 'token');
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
          print('DIOERROR MESSAGE===== ${e.message}');
          Get.back();
          Dialogs.instance.showSnackBar(
            DialogType.error,
            'No se pudo conectar al servidor, intentalo de nuevo más tarde!',
          );
        }
      }
    } else {
      Dialogs.instance.dismiss();
      Dialogs.instance.showSnackBar(
        DialogType.error,
        'Se canceló el inicio de sesión',
      );
      print(result.status);
      print(result.message);
    }
  }

  Future getUserInfo() async {
    final token = await SecureStorage.instance.readItem('token');
    dio.FormData _data = dio.FormData.fromMap({
      "token": token,
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
        print('REFRESH TOKEN======== ${response.data['data']['token']}');
        final token = response.data['data']['token'];

        await SecureStorage.instance.addNewItem(token, 'token');
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

        return false;
      }
    }
  }

  Future<void> logOut() async {
    await FacebookAuth.instance.logOut();

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
