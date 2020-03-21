import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/map_worker.dart';

import 'Models/station.dart';

class RouteMenu extends StatefulWidget {
  final RouteData _route;

  RouteMenu(this._route);

  @override
  RouteMenuState createState() {
    return RouteMenuState(_route);
  }
}

class RouteMenuState extends State {
  final RouteData _route;
  static Widget _stationsWidget;
  static Widget _confirmWidget;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    _stationsWidget,
    _confirmWidget,
  ];

  RouteMenuState(this._route);

  void initState() {
    _widgetOptions[0] = _stationsList(_route.stations);
    _widgetOptions[1] = _confirm(1);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Future<void> _warningAlert(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: const Text(
  //             'Вы уже находитесь в месте, которое выбрали как цель маршрута!'),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Назад'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _getToTheMap(MapData mapData) {
    NavigationManager.push(context, MapsPage(mapData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavigationManager.pop(context);
        },
        child: Text(_route.busNumber, style: TextStyle(fontSize: 30)),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text('Остановки'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.beenhere),
            title: Text('Подтверждение'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _confirm(int index) {
    return SafeArea(
        child: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
              child: Text(
            "Проверьте правильность данных",
            style: TextStyle(fontSize: 20),
          ))),
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
              child: Column(children: [
            Text(
                "Вы направляетесь в сторону конечной: ${_route.stations[_route.stations.length - 1].name}",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center),
            SizedBox(
              height: 30,
            ),
            Text("Ваша следующая остановка: ${_route.stations[index].name}",
                style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
          ]))),
      Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Center(
                  child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _getToTheMap(MapData(_route, index));
                        });
                      },
                      color: Colors.green[500],
                      child: Text("В путь!")))))
    ]));
  }

  Widget _stationsList(List<Station> stations) {
    return SafeArea(
        child: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Center(
              child: Text(
            "Выберите остановку, к которой вы прямо сейчас поедете",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ))),
      Flexible(
          child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(stations[index].name,
                style: TextStyle(color: Colors.black)),
            onTap: () => {
              setState(() {
                _widgetOptions[1] = _confirm(index);
              }),
              _onItemTapped(1)
            },
          ));
        },
      ))
    ]));
  }
}
