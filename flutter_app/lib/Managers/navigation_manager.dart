import 'package:flutter/material.dart';
import 'package:flutter_app/prefs_manager.dart';

class NavigationManager {
  static void push(BuildContext context, Widget to) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => to),
    );
  }
}
