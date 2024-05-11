import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  static Future<bool> saveKey(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    // write key
    await prefs.setString(key, value);
    if (kDebugMode) {
      print("Saved key: ${prefs.get(key)}");
    }
    return true;
  }

  static Future<String?> readKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // read key
    if (kDebugMode) {
      print("Read key:$key, value: ${prefs.getString(key)}");
    }
    if (prefs.getString(key) == null) {
      return "";
    }
    return prefs.getString(key);
  }

  static Future<bool> removeKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    // remove key
    await prefs.remove(key);
    if (kDebugMode) {
      print("Remove key: $key");
    }
    return true;

  }
}