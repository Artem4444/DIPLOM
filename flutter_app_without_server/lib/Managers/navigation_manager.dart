import 'package:flutter/material.dart';

class NavigationManager {
  static void push(BuildContext context, Widget to) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => to),
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
