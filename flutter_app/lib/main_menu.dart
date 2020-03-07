import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/route_menu.dart';

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
            subtitle: Row(children: [
              Text(startStation),
              Icon(Icons.linear_scale),
              Text(endStation)
            ]),
            onTap: () => {NavigationManager.push(context, RouteMenu())}));
  }
}
