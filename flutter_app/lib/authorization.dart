import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/prefs_manager.dart';
import 'package:flutter_app/Models/user.dart';
import 'package:flutter_app/main_menu.dart';
import 'Managers/network_manager.dart';

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

class AuthorizationState extends State {
  final _loginFormKey = GlobalKey<FormState>();
  final _registrationFormKey = GlobalKey<FormState>();
  static Widget currentState;
  User _registrationUser = new User();
  User _loginUser = new User();
  double _greatingsOpacity = 0;
  bool _isLoginWidget;
  bool _canMoveToMenu;

  void _getPrefs() async {
    _loginUser.firstName = await PrefsManager.getUserName();
    if (_loginUser.firstName == null || _loginUser.firstName == "")
      _showLogin();
    else
      _showGreatings();
  }

  void _showLogin() {
    setState(() {
      currentState = _loginWidget();
      _isLoginWidget = true;
      _greatingsOpacity = 1;
    });
  }

  void _showRegistration() {
    setState(() {
      currentState = _registrationWidget();
      _isLoginWidget = false;
    });
  }

  void _showGreatings() {
    setState(() {
      currentState = _greatingsWidget();
      _isLoginWidget = false;
      _canMoveToMenu = true;
      _greatingsOpacity = 1;
    });
    Timer(Duration(seconds: 3), () {
      if (!_isLoginWidget && _canMoveToMenu)
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
    NetworkManager.startListenConectionState(
        () => {print("NOOOOOOOOOOOOOOOOOO!!!!")});
    setState(() {
      currentState = NetworkManager.loadWidget();
    });
    _getPrefs();
  }

  @override
  void dispose() {
    NetworkManager.removeConectionListener();
    super.dispose();
  }

  _backPressHandler() {
    if (_isLoginWidget)
      exit(0);
    else
      setState(() {
        currentState = _loginWidget();
        _isLoginWidget = true;
        _canMoveToMenu = false;
      });
  }

  Future<bool> _onBackPressed() {
    return _backPressHandler() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: _onBackPressed,
            child: SafeArea(
                child: AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: _greatingsOpacity,
                    child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                              Colors.blue[200],
                              Colors.blueAccent[400]
                            ])),
                        child: AnimatedSwitcher(
                            duration: Duration(seconds: 1),
                            child: currentState))))));
  }

  Widget _greatingsWidget() {
    return Center(
        child: Text(
      "Добро пожаловать ${_loginUser.firstName}!",
      style: TextStyle(fontSize: 30, color: Colors.white),
      textAlign: TextAlign.center,
    ));
  }

  Widget _registrationWidget() {
    return Center(
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text("Регистрация",
              style: TextStyle(fontSize: 30, color: Colors.white))),
      Form(
          key: _registrationFormKey,
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(children: [
                TextFormField(
                  decoration: _inputDecoration("Имя", Icons.person),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Введите имя!';
                    else if (!value.contains(new RegExp("[а-яА-Я]")))
                      return "Только кирилличиские символы!";
                    else {
                      _registrationUser.firstName = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: _inputDecoration("Фамилия", Icons.person),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Введите фамилию!';
                    else if (!value.contains(new RegExp("[а-яА-Я]")))
                      return "Только кирилличиские символы!";
                    else {
                      _registrationUser.secondName = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: _inputDecoration(
                      "Номер мобильного телефона", Icons.device_unknown),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Введите полный номер!';
                    else if (!value.contains(new RegExp(r"^\+375[0-9]{9}$")))
                      return "Не корректный номер! Пример:+375295264295";
                    else {
                      _registrationUser.mobileNumber = value;
                      return null;
                    }
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
                    if (value.isEmpty)
                      return 'Введите пароль!';
                    else if (value.length < 4)
                      return "Не менее 4 символов!";
                    else {
                      _registrationUser.password = value;
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: _inputDecoration(
                      "Подтвердите пароль", Icons.screen_lock_portrait),
                  validator: (value) {
                    if (_registrationUser.password != value)
                      return 'Введенные пароли не совпадают!';
                    else if (value.isEmpty)
                      return 'Подтвердите пароль!';
                    else {
                      _registrationUser.mobileNumber = value;
                      return null;
                    }
                  },
                )
              ]))),
      Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: _raisedButton('Зарегистрироваться', Colors.green[300], () {
              if (_registrationFormKey.currentState.validate()) {
                print("registration!");
              }
            })),
        Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: _raisedButton('Вход', Colors.blue[300], () {
              _showLogin();
            }))
      ]))
    ])));
  }

  Widget _loginWidget() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Text("Вход",
              style: TextStyle(fontSize: 30, color: Colors.white))),
      Form(
          key: _loginFormKey,
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(children: [
                TextFormField(
                  decoration: _inputDecoration(
                      "Номер мобильного телефона", Icons.device_unknown),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Введите полный номер!';
                    else if (!value.contains(new RegExp(r"^\+375[0-9]{9}$")))
                      return "Не корректный номер! Пример:+375295264295";
                    else {
                      _loginUser.mobileNumber = value;
                      return null;
                    }
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
                    } else {
                      _loginUser.password = value;
                      return null;
                    }
                  },
                ),
              ]))),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _raisedButton('Вход', Colors.blue[300], () {
          if (_loginFormKey.currentState.validate()) {
            _sendUserLogin(_loginUser);
          }
        }),
        SizedBox(
          width: 20,
        ),
        _raisedButton('Регистрация', Colors.green[300], () {
          _showRegistration();
        })
      ])
    ]));
  }

  InputDecoration _inputDecoration(String text, IconData icon) {
    return InputDecoration(
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        border: OutlineInputBorder(),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white),
        icon: Icon(
          icon,
          color: Colors.white,
        ));
  }

  RaisedButton _raisedButton(String text, Color color, Function onPresed) {
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
