import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/map_worker.dart';

import 'Managers/navigation_manager.dart';

class RoutePage extends StatefulWidget {
  final String _routeNumber;
  RoutePage(this._routeNumber);

  @override
  RoutePageState createState() {
    return RoutePageState(_routeNumber);
  }
}

class RoutePageState extends State {
  List<String> station;
  List<StationListItem> stationList = List<StationListItem>();
  final String _routeNumber;
  RoutePageState(this._routeNumber);

  void _getStations() async {
    station = await NetworkManager.readStations();
    setState(() {
      for (int i = 0; i < station.length; i++) {
        stationList.add(StationListItem(station[i]));
      }
    });
  }

  void initState() {
    _getStations();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Column(children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(width: 3),
                  shape: BoxShape.circle,
                  color: Colors.cyan,
                ),
                child: Center(
                    child: Text(
                  _routeNumber,
                  style: TextStyle(fontSize: 30),
                )),
              ),
              Row(children: [
                Flexible(
                    child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: stationList.length,
                  itemBuilder: (context, index) {
                    return stationList[index];
                  },
                )),
                Expanded(
                    child: Container(
                        child: Center(
                            child: Column(children: [
                  Text("Выберите направление:"),
                  RaisedButton(
                      onPressed: () {
                        NavigationManager.push(
                            context, MapsPage(_routeNumber, station[0]));
                      },
                      child: Text("К ${station[0]}")),
                  RaisedButton(
                      onPressed: () {
                        NavigationManager.push(
                            context,
                            MapsPage(
                                _routeNumber, station[station.length - 1]));
                      },
                      child: Text("К ${station[station.length - 1]}"))
                ]))))
              ])
            ]))));
  }
}

class StationListItem extends StatelessWidget {
  final String _stationName;

  StationListItem(this._stationName);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(
      _stationName,
      style: TextStyle(color: Colors.black),
    )));
  }
}
