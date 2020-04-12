import 'package:flutter/material.dart';

import 'buttons.dart';

class Alerts {
  static Widget noInternetWidget(Function buttonOnclick) {
    return Center(
        key: ValueKey<String>("NoInternetWithOptions"),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Не удается отправить данные. Проверьте подключение к интернету",
            style: TextStyle(fontSize: 30, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Buttons.raisedButton(
                  "Продолжить", Colors.red[400], buttonOnclick))
        ]));
  }

  static Widget responseWidget(String warning, Color buttonColor,
      String buttonLabel, Function buttonOnclick) {
    return Center(
        key: ValueKey<String>("Response"),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            warning,
            style: TextStyle(fontSize: 30, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child:
                  Buttons.raisedButton(buttonLabel, buttonColor, buttonOnclick))
        ]));
  }

  static Widget noInternetWidgetWithoutButton() {
    return Flexible(
      key: ValueKey<String>("NoInternet"),
        child: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Text(
            "Не удается обновить данные. Проверьте подключение к интернету",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ]))));
  }
}
