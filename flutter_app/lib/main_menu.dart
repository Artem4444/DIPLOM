import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/app_repository.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/authorization.dart';
import 'package:flutter_app/route_menu.dart';
import 'Templates/alerts.dart';
import 'authorization.dart';

class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState() {
    return MainMenuState();
  }
}

class MainMenuState extends State {
  List<Widget> routeList = List<Widget>();
  Widget currentState;

  _getRoutes() async {
    _setLoadingWidget();
    try {
      List<RouteData> routesDatas = await NetworkManager.getRoutes();
      setState(() {
        for (var route in routesDatas) {
          routeList.add(_listItem(route));
        }
        currentState = _routeList();
      });
    } on NotReachServerException {
      _showWarning("Не удается связаться с сервером");
    }
  }

  void _showWarning(String warning) {
    setState(() {
      currentState =
          Alerts.responseWidget(warning, Colors.red[400], _getRoutes);
    });
  }

  void _setLoadingWidget() {
    setState(() {
      currentState = NetworkManager.loadWidget();
    });
  }

  @override
  void initState() {
    _getRoutes();
  }

  _closeUserProfile() async {
    await AppRepository.clearLocalUser();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => Authorization()));
  }

  _killApp() {
    exit(0);
  }

  Future<bool> _onBackPressed() {
    return _killApp() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                          Colors.blue[200],
                          Colors.blueAccent[400]
                        ])),
                    child: currentState))));
  }

  Widget _routeList() {
    return Container(
        child: Column(children: [
      Container(
        decoration: BoxDecoration(color: Colors.blue[50]),
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Row(children: [
          Row(children: [
            Icon(Icons.person),
            Text(AppRepository.localUser.firstName)
          ]),
          SizedBox(
            width: 130,
          ),
          Expanded(
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.blue[300],
                  child: Text("Выйти из профиля"),
                  onPressed: () {
                    _closeUserProfile();
                  }))
        ]),
      ),
      Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ListView.builder(
                itemCount: routeList.length,
                itemBuilder: (context, index) {
                  return routeList[index];
                },
              )))
    ]));
  }

  Widget _listItem(RouteData route) {
    return Card(
        elevation: 7,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(30)),
        child: ListTile(
            leading: Container(
                alignment: Alignment.center,
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  shape: BoxShape.circle,
                  color: Colors.green[500],
                ),
                child: Text(route.busNumber,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center)),
            title: Text(route.routeName),
            onTap: () => {NavigationManager.push(context, RouteMenu(route))}));
  }
}
