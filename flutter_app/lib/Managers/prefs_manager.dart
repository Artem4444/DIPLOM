import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static Future<String> getUserJson() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("UserJson") ?? "";
  }

  static void setUserJson(String json) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("UserJson", json);
  }

  static void clearPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
