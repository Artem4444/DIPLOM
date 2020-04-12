import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/app_repository.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Models/user.dart';
import 'package:flutter_app/main_menu.dart';
import 'Managers/network_manager.dart';
import 'Templates/alerts.dart';
import 'Templates/buttons.dart';

class Authorization extends StatefulWidget {
  @override
  AuthorizationState createState() {
    return AuthorizationState();
  }
}

enum AuthorizationPage { login, registration, greatings }

class AuthorizationState extends State {
  final _loginFormKey = GlobalKey<FormState>();
  final _registrationFormKey = GlobalKey<FormState>();
  static Widget currentState;
  User _registrationUser = new User("", "", "", "", "");
  User _loginUser;
  AuthorizationPage authorizationPage;
  double _greatingsOpacity = 0;

  void _getLocalData() async {
    _loginUser = await AppRepository.getLocalUser();
    if (_loginUser == null) {
      _loginUser = new User("", "", "", "", "");
      _showLogin();
    } else
      _showGreatings();
  }

  void _showLogin() {
    setState(() {
      currentState = _loginWidget();
      authorizationPage = AuthorizationPage.login;
      _greatingsOpacity = 1;
    });
  }

  void _showRegistration() {
    setState(() {
      currentState = _registrationWidget();
      authorizationPage = AuthorizationPage.registration;
    });
  }

  void _showNoConection() {
    setState(() {
      currentState = Alerts.noInternetWidget(_setPreviousWidget);
    });
  }

  void _showWarning(String warning) {
    setState(() {
      currentState = Alerts.responseWidget(
          warning, Colors.red[400], "Повторить", _setPreviousWidget);
    });
  }

  void _showSucces(String succesMesage) {
    setState(() {
      currentState = Alerts.responseWidget(
          succesMesage, Colors.green[400], "Продолжить", _setPreviousWidget);
    });
  }

  void _setPreviousWidget() {
    if (authorizationPage == AuthorizationPage.login)
      _showLogin();
    else
      _showRegistration();
  }

  void _showGreatings() {
    setState(() {
      currentState = _greatingsWidget();
      authorizationPage = AuthorizationPage.greatings;
      _greatingsOpacity = 1;
    });
    Timer(Duration(seconds: 3), () {
      if (authorizationPage == AuthorizationPage.greatings)
        NavigationManager.push(context, MainMenu());
    });
  }

  _sendUserLogin(User user) async {
    _setLoadingWidget();
    if (!NetworkManager.isConected)
      _showNoConection();
    else {
      try {
        var response = await NetworkManager.login(user);
        if (response.statusCode == 200) {
          await AppRepository.setLocalUser(response.body);
          _showGreatings();
        } else
          _showWarning(response.body);
      } on NotReachServerException {
        _showWarning("Не удается связаться с сервером");
      }
    }
  }

  void _registrateUser(User user) async {
    _setLoadingWidget();
    if (!NetworkManager.isConected)
      _showNoConection();
    else {
      try {
        var response = await NetworkManager.registration(user);
        if (response.statusCode == 200) {
          _showSucces(response.body);
          authorizationPage = AuthorizationPage.login;
        } else {
          _showWarning(response.body);
        }
      } on NotReachServerException {
        _showWarning("Не удается связаться с сервером");
      }
    }
  }

  void _setLoadingWidget() {
    setState(() {
      currentState = NetworkManager.loadWidget();
    });
  }

  @override
  void initState() {
    NetworkManager.startListenConectionState(null);
    _setLoadingWidget();
    _getLocalData();
  }

  @override
  void dispose() {
    NetworkManager.removeConectionListener();
    super.dispose();
  }

  _backPressHandler() {
    if (authorizationPage == AuthorizationPage.login ||
        authorizationPage == null)
      exit(0);
    else
      setState(() {
        currentState = _loginWidget();
        authorizationPage = AuthorizationPage.login;
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
                            duration: Duration(milliseconds: 250),
                            child: currentState))))));
  }

  Widget _greatingsWidget() {
    return Center(
        key: ValueKey<String>("Greatings"),
        child: Text(
          "Добро пожаловать ${AppRepository.localUser.firstName}!",
          style: TextStyle(fontSize: 30, color: Colors.white),
          textAlign: TextAlign.center,
        ));
  }

  Widget _registrationWidget() {
    return Center(
        key: ValueKey<String>("Registration"),
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
                      initialValue: _registrationUser.firstName,
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
                      initialValue: _registrationUser.secondName,
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
                      initialValue: _registrationUser.mobileNumber,
                      decoration: _inputDecoration(
                          "Номер мобильного телефона", Icons.device_unknown),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Введите полный номер!';
                        else if (!value
                            .contains(new RegExp(r"^\+375[0-9]{9}$")))
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
                      decoration: _inputDecoration(
                          "Пароль", Icons.screen_lock_portrait),
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
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Buttons.raisedButton(
                    'Зарегистрироваться', Colors.green[300], () {
                  if (_registrationFormKey.currentState.validate()) {
                    _registrateUser(_registrationUser);
                  }
                })),
            Container(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Buttons.raisedButton('Вход', Colors.blue[300], () {
                  _showLogin();
                }))
          ]))
        ])));
  }

  Widget _loginWidget() {
    return Center(
        key: ValueKey<String>("Login"),
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
                      initialValue: _loginUser.mobileNumber,
                      decoration: _inputDecoration(
                          "Номер мобильного телефона", Icons.device_unknown),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Введите полный номер!';
                        else if (!value
                            .contains(new RegExp(r"^\+375[0-9]{9}$")))
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
                      initialValue: _loginUser.password,
                      obscureText: true,
                      decoration: _inputDecoration(
                          "Пароль", Icons.screen_lock_portrait),
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
            Buttons.raisedButton('Вход', Colors.blue[300], () {
              if (_loginFormKey.currentState.validate()) {
                _sendUserLogin(_loginUser);
              }
            }),
            SizedBox(
              width: 20,
            ),
            Buttons.raisedButton('Регистрация', Colors.green[300], () {
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
}
