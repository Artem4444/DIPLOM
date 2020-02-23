import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<String> getUserName() async {
    SharedPreferences pref = _getPrefs();
    return pref.getString("UserName") ?? "";
  }

  static void setUserName(String name) async {
    SharedPreferences pref = _getPrefs();
    pref.setString("UserName", name);
  }
}
