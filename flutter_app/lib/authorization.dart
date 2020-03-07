import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/prefs_manager.dart';
import 'package:flutter_app/Models/user.dart';
import 'package:flutter_app/main_menu.dart';

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

class AuthorizationState extends State {
  final _formKey = GlobalKey<FormState>();
  static Widget currentState;
  User _user = new User();

  void _getPrefs() async {
    _user.name = await PrefsManager.getUserName();
    if (_user.name == null || _user.name == "") {
      setState(() {
        currentState = _loginWidget();
      });
    } else {
      _showGreatings();
    }
  }

  void _showGreatings() {
    setState(() {
      currentState = _greatingsWidget();
    });
    Timer(Duration(seconds: 3), () {
      NavigationManager.push(context, MainMenu());
    });
  }

  void _sendUserLogin(User user) {
    if (true) {
      PrefsManager.setUserName("Artem");
      _showGreatings();
    }
  }

  @override
  void initState() {
    setState(() {
      currentState = _loadWidget();
    });
    _getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: currentState));
  }

  Widget _greatingsWidget() {
    return Center(child: Text("Добро пожаловать ${_user.name}!"));
  }

  Widget _registrationWidget() {
    return Container(child: Column(children: [Text("Регистрация")]));
  }

  Widget _loginWidget() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text("Вход",
              style: TextStyle(fontSize: 30, color: Colors.blueAccent))),
      Form(key: _formKey,
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(children: [
                TextFormField(
                  decoration: _inputDecoration(
                      "Номер мобильного телефона", Icons.device_unknown),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Введите полный номер!';
                    }
                    _user.mobileNumber = value;
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration:
                      _inputDecoration("Пароль", Icons.screen_lock_portrait),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Введите пароль!';
                    }
                    _user.password = value;
                    return null;
                  },
                ),
              ]))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _raisedButton('Вход', Colors.blueAccent, () {
          if (_formKey.currentState.validate()) {
            _sendUserLogin(_user);
          }
        }),
        SizedBox(
          width: 20,
        ),
        _raisedButton('Регистрация', Colors.greenAccent, () {
          setState(() {
            currentState = _registrationWidget();
          });
        })
      ])
    ]);
  }

  InputDecoration _inputDecoration(String text, IconData icon) {
    return InputDecoration(
        border: OutlineInputBorder(), labelText: text, icon: Icon(icon));
  }

  RaisedButton _raisedButton(String text, Color color, Function onPresed) {
    return RaisedButton(
      elevation: 3,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onPresed,
      child: Text(text),
    );
  }

  Widget _loadWidget() {
    return Center(
        child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ));
  }
}
