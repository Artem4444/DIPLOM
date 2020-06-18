import 'dart:ui';

import 'package:flutter/material.dart';

class Buttons {
  static RaisedButton raisedButton(
      String text, Color color, Function onPresed) {
    return RaisedButton(
      elevation: 3,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 1, color: Colors.white),
      ),
      onPressed: onPresed,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
