import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rtiapp/src/common/models/user.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/initial-setup/models/query_status.dart';
import 'package:rtiapp/src/initial-setup/models/status.model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'init()',
    });
    _prefs = await SharedPreferences.getInstance();
  }

  //------------------------------------
  // CRUD ✅ SAVE ->  SAVE token
  //------------------------------------
  static Future<bool> saveToken(String key, String value) {
    return _prefs.setString(key, value);
  }

  //------------------------------------
  // CRUD 🔽 READ ->  READ token
  //------------------------------------
  static String? getToken(String key) {
    return _prefs.getString(key);
  }

  //------------------------------------
  // CRUD ❌ DELETE ->  DELETE token
  //------------------------------------
  static Future<bool> removeToken(String key) async {
    await deleletUserInfo();
    return _prefs.remove(key);
  }

//------------------------------------
// CRUD ✅ SAVE ->  SAVE username and password
//------------------------------------
  static Future<void> saveUserInfo(
      String username, String email, int userId, String accessToken) async {
    var obj = UserModel(id: userId, username: username, email: email);
    await _prefs.setString("userInfo", json.encode(obj.toJson()));
  }

//------------------------------------
// CRUD 🔽 READ ->  READ username and password and return as Map<String,dynamic>
//------------------------------------
  static UserModel? getUserInfo() {
    String? userInfoJson = _prefs.getString("userInfo");
    if (userInfoJson == null) {
      return null;
    }

    Map<String, dynamic> userInfoMap = json.decode(userInfoJson);
    return UserModel.fromJson(userInfoMap);
  }

  static Future<bool> deleletUserInfo() {
    return _prefs.remove('userInfo');
  }

  static bool? isStaff() {
    var token = _prefs.getString("token");
    if (token != null) {
      var decoded = JwtDecoder.decode(token);
      if (decoded["role"] == "staff") {
        return true;
      } else {
        return false;
      }
    }
    return null;
  }

  static Future<void> saveStatus(List<StatusModel> data) async {
    List<String> jsonList =
        data.map((status) => json.encode(status.toJson())).toList();
    await _prefs.setStringList('status', jsonList);
    logger.i({"saved": jsonList});
  }

  static Future<List<StatusModel>?> getStatus() async {
    List<String>? jsonList = _prefs.getStringList('status');
    if (jsonList == null) {
      return null;
    }
    return jsonList
        .map((jsonString) => StatusModel.fromJson(json.decode(jsonString)))
        .toList();
  }

  static Future<void> saveQueryStatus(List<QueryStatusModel> data) async {
    List<String> jsonList =
        data.map((status) => json.encode(status.toJson())).toList();
    await _prefs.setStringList('query-status', jsonList);
    logger.i({"saved": jsonList});
  }

  static Future<List<QueryStatusModel>?> getQueryStatus() async {
    List<String>? jsonList = _prefs.getStringList('query-status');
    if (jsonList == null) {
      return null;
    }
    return jsonList
        .map((jsonString) => QueryStatusModel.fromJson(json.decode(jsonString)))
        .toList();
  }
}
