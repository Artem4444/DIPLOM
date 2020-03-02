import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/route_menu.dart';
import 'package:flutter_app/route_page.dart';

class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState() {
    return MainMenuState();
  }
}

class MainMenuState extends State {
  List<ListItem> listItems = List<ListItem>();

  void _getRoutes() async {
    List<RouteData> routesDatas = await NetworkManager.readRoutes();
    setState(() {
      for (var route in routesDatas) {
        listItems.add(
            ListItem(route.routenumber, route.startStation, route.endStation));
      }
    });
  }

  @override
  void initState() {
    _getRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Container(
                    child: Column(children: [
              TopOfMenu("HEHEHE"),
              Expanded(
                  child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return listItems[index];
                },
              ))
            ])))));
  }
}

class ListItem extends StatelessWidget {
  final String routeNumber;
  final String startStation;
  final String endStation;

  ListItem(this.routeNumber, this.startStation, this.endStation);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(routeNumber, style: TextStyle(color: Colors.black)),
            subtitle: Text("$startStation <---> $endStation",
                style: TextStyle(color: Colors.black)),
            onTap: () => {
                  NavigationManager.push(context, RouteMenu()/*RoutePage(routeNumber)*/),
                }));
  }
}

class TopOfMenu extends StatelessWidget {
  final String _userName;

  TopOfMenu(this._userName);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(child: Text(_userName)),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.black)),
              child: Icon(Icons.person_outline),
              onPressed: () => {print("To user settings")})
        ],
      ),
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white54,
          border: Border(
              top: BorderSide(),
              right: BorderSide(),
              left: BorderSide(),
              bottom: BorderSide())),
    );
  }
}
