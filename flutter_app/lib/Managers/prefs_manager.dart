import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static Future<String> getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("UserName") ?? "";
  }

  static void setUserName(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ;
    pref.setString("UserName", name);
  }

  static void clearPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
