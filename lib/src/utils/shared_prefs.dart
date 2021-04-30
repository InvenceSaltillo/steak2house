import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._internal();
  static SharedPrefs _instance = SharedPrefs._internal();
  static SharedPrefs get instance => _instance;

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  setUserInfo(value) {
    _prefs!.setString('user', json.encode(value));
  }

  Future getUserInfo() async {
    return await json.decode(_prefs!.getString('user')!);
  }
}
