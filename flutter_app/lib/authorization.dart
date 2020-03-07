import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/prefs_manager.dart';
import 'package:flutter_app/Models/user.dart';
import 'package:flutter_app/main_menu.dart';
import 'package:flutter_app/route_menu.dart';

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
      print("TO MENU");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainMenu()));
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
    return  Scaffold(body: SafeArea(child: currentState));
  }

  Widget _greatingsWidget() {
    return Center(child: Text("Добро пожаловть ${_user.name}!"));
  }

  Widget _registrationWidget() {
    return Container(child: Column(children: [Text("Регистрация")]));
  }

  Widget _loginWidget() {
    return Container(
        child: Column(children: [
      Text("Вход"),
      Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Номер мобильного телефона",
                  icon: Icon(Icons.device_unknown)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите полный номер вашего мобильного телефона!';
                }
                _user.mobileNumber = value;
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Пароль",
                  icon: Icon(Icons.screen_lock_portrait)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Введите пароль!';
                }
                _user.password = value;
                return null;
              },
            ),
            Row(children: [
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _sendUserLogin(_user);
                  }
                },
                child: Text('Вход'),
              ),
              RaisedButton(
                onPressed: () {
                  setState(() {
                    currentState = _registrationWidget();
                  });
                },
                child: Text('Регистрация'),
              )
            ])
          ]))
    ]));
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
