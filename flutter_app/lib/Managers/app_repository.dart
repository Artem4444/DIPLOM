import 'dart:convert';

import 'package:flutter_app/Managers/prefs_manager.dart';
import 'package:flutter_app/Models/user.dart';

class AppRepository {
  static User localUser;

  static Future<User> getLocalUser() async {
    if (localUser == null) {
      String userJson = await PrefsManager.getUserJson();
      if (userJson == null || userJson == "") return null;
      Map userMap = jsonDecode(userJson);
      localUser = User.fromJson(userMap);
    }
    return localUser;
  }

  static setLocalUser(String userJson) async {
    await PrefsManager.setUserJson(userJson);
    Map userMap = jsonDecode(userJson);
    localUser = User.fromJson(userMap);
  }

  static clearLocalUser() async {
    localUser = null;
    await PrefsManager.clearPrefs();
  }
}
