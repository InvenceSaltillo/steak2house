import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._internal();
  static SharedPrefs _instance = SharedPrefs._internal();
  static SharedPrefs get instance => _instance;

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  Future getKey(String key) async {
    return await json.decode(_prefs.getString(key)!);
  }

  Future getCreatedAt() async {
    return _prefs.getString('createdAt');
  }

  Future setKey(String key, value) async {
    _prefs.setString(key, value);
  }

  Future<bool> deleteKey(String key) {
    return _prefs.remove(key);
  }

  Future<bool> clearPrefs() {
    return _prefs.clear();
  }
}
