import 'package:flutter/material.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/map_worker.dart';

import 'Managers/network_manager.dart';

class RouteMenu extends StatefulWidget {
  final int _routeNumber;

  RouteMenu(this._routeNumber);

  @override
  RouteMenuState createState() {
    return RouteMenuState(_routeNumber);
  }
}

class RouteMenuState extends State {
  RouteMenuData routeData = RouteMenuData();
  final int _routeNumber;
  List<String> _stations;
  static Widget _stationsWidget;
  static Widget _directionWidget;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    _stationsWidget,
    _directionWidget,
  ];

  RouteMenuState(this._routeNumber);
  void initState() {
    _loadStations();
  }

  void _loadStations() {
    setState(() {
      _widgetOptions[0] = NetworkManager.loadWidget();
      _widgetOptions[1] = NetworkManager.loadWidget();
    });
    _getStations();
  }

  void _getStations() async {
    _stations = await NetworkManager.readStations();
    setState(() {
      _stationsWidget = _filledsStationsWidget(_stations);
      _directionWidget = _filledDirrectionWidget(_stations);
      _widgetOptions[0] = _stationsWidget;
      _widgetOptions[1] = _directionWidget;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _warningAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'Вы уже находитесь в месте, которое выбрали как цель маршрута!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Назад'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _getToTheMap(MapData mapData) {
    if (routeData.currentStationIndex == routeData.endStationIndex) {
      _warningAlert(context);
      return;
    } else {
      NavigationManager.push(context, MapsPage(mapData));
    }
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
        child: Text(_routeNumber.toString(),
        style: TextStyle(fontSize: 30)),
        elevation: 2.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.airport_shuttle),
            title: Text('Остановки'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_vert),
            title: Text('Направление'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
        child: Center(
            child: Column(children: [
      Icon(Icons.error_outline, color: Colors.red),
      RaisedButton(
        onPressed: () {
          _loadStations();
        },
        child: Text("Не удалось загрузить данные. Попробовать ещё раз"),
      )
    ])));
  }

  Widget _filledDirrectionWidget(List<String> stations) {
    return SafeArea(
        child: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
              child: Text(
            "Выберите направление маршрута",
            style: TextStyle(fontSize: 20),
          ))),
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
              child: Text(
            "От остановки ${stations[routeData.currentStationIndex]}",
            style: TextStyle(fontSize: 25),
          ))),
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
              child: Column(children: [
            RaisedButton(
                onPressed: () {
                  setState(() {
                    routeData.endStationIndex = 0;
                  });
                  _getToTheMap(
                      new MapData(routeData.currentStationIndex, false));
                },
                child: Text("В направлении к ${stations[0]}")),
            RaisedButton(
                onPressed: () {
                  setState(() {
                    routeData.endStationIndex = stations.length - 1;
                  });
                  _getToTheMap(
                      new MapData(routeData.currentStationIndex, true));
                },
                child: Text("В направлении к ${stations[stations.length - 1]}"))
          ])))
    ]));
  }

  Widget _filledsStationsWidget(List<String> stations) {
    return SafeArea(
        child: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Center(
              child: Text(
            "Выберите пункт отправления",
            style: TextStyle(fontSize: 20),
          ))),
      Flexible(
          child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            title: Text(stations[index], style: TextStyle(color: Colors.black)),
            onTap: () => {
              setState(() {
                routeData.currentStationIndex = index;
                _widgetOptions[1] = _filledDirrectionWidget(_stations);
              }),
              _onItemTapped(1)
            },
          ));
        },
      ))
    ]));
  }
}
