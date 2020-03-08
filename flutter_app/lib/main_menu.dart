import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Managers/prefs_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/authorization.dart';
import 'package:flutter_app/route_menu.dart';

import 'Models/user.dart';
import 'authorization.dart';

class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState() {
    return MainMenuState();
  }
}

class MainMenuState extends State {
  User user = User();
  List<Widget> listItems = List<Widget>();
  Widget currentState;

  _getRoutes() async {
    List<RouteData> routesDatas = await NetworkManager.readRoutes();
    setState(() {
      for (var route in routesDatas) {
        listItems.add(_listItem(route));
      }
      currentState = _routeList();
    });
  }

  _setUserName() async {
    user.name = await PrefsManager.getUserName();
  }

  @override
  void initState() {
    setState(() {
      currentState = NetworkManager.loadWidget();
    });
    _setUserName();
    _getRoutes();
  }

  _closeUserProfile() async {
    await PrefsManager.clearPrefs();
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
            body: SafeArea(child: currentState)));
  }

  Widget _routeList() {
    return Container(
        child: Column(children: [
      Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: Row(children: [
          Row(children: [Icon(Icons.person_pin), Text(user.name)]),
          SizedBox(
            width: 130,
          ),
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.cyan[300],
              child: Text("Выйти из профиля"),
              onPressed: () {
                _closeUserProfile();
              })
        ]),
      ),
      Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return listItems[index];
                },
              )))
    ]));
  }

  Widget _listItem(RouteData route) {
    return Card(
        elevation: 7,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: ListTile(
            leading: Container(
                alignment: Alignment.center,
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: Text(route.routeNumber.toString(),
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    textAlign: TextAlign.center)),
            title: Row(children: [
              Text(route.startStation),
              Icon(Icons.linear_scale),
              Text(route.endStation)
            ]),
            onTap: () => {NavigationManager.push(context, RouteMenu(route.routeNumber))}));
  }
}
