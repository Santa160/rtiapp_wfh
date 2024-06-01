import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rtiapp/src/core/logger.dart';
import 'package:rtiapp/src/feature/admin/rti-status/models/res_models/rti.model.dart';
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
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'saveToken',
      "Token saved": value
    });
    return _prefs.setString(key, value);
  }

  //------------------------------------
  // CRUD 🔽 READ ->  READ token
  //------------------------------------
  static String? getToken(String key) {
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'getToken',
      "key": key,
      "token": _prefs.getString(key),
      "username": _prefs.getString('username'),
      "password": _prefs.getString('password')
    });
    return _prefs.getString(key);
  }

  //------------------------------------
  // CRUD ❌ DELETE ->  DELETE token
  //------------------------------------
  static Future<bool> removeToken(String key) {
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'removeToken',
      "key": key,
      "token": _prefs.remove(key),
    });
    return _prefs.remove(key);
  }

//------------------------------------
// CRUD ✅ SAVE ->  SAVE username and password
//------------------------------------
  static Future<void> saveUserInfo(String username, String pwd) async {
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'saveUserDataToRemember',
      "username": username,
      "password": pwd,
    });
    _prefs.setString("username", username);
    _prefs.setString("password", pwd);
  }

//------------------------------------
// CRUD 🔽 READ ->  READ username and password and return as Map<String,dynamic>
//------------------------------------
  static Map<String, dynamic> readUserInfo(String username, String pwd) {
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'readUserNameAndPassword',
      "data": {
        "username": _prefs.getString('username'),
        "password": _prefs.getString('password')
      },
    });
    return {
      "username": _prefs.getString('username') ?? '',
      "password": _prefs.getString('password') ?? ''
    };
  }

  static Map<String, dynamic> deleletUserInfo() {
    logger.i({
      "class": "SharedPrefHelper",
      "method": 'deleletUserInfo',
      "data": {
        "username": _prefs.remove('username'),
        "password": _prefs.remove('password')
      },
    });
    return {
      "username": _prefs.remove('username'),
      "password": _prefs.remove('password')
    };
  }

  static bool isAdmin({String? isAdmin}) {
    
    if (isAdmin != null) {
      // logger.i("saving");
      _prefs.setBool("admin", isAdmin == "admin" ? true : false);

      return (_prefs.containsKey("admin")) ? _prefs.getBool("admin")! : false;
    } else {
      // logger.i("getting");
      return (_prefs.containsKey("admin")) ? _prefs.getBool("admin")! : false;
    }
  }



 
}

