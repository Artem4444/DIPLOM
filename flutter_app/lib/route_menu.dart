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

  void _getToTheMap(MapData mapData) {
    NavigationManager.push(context, MapsPage(mapData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue[200], Colors.blueAccent[400]])),
          child: Center(
            child: AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: _widgetOptions.elementAt(_selectedIndex)),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[500],
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
            style: TextStyle(fontSize: 20, color: Colors.white),
          ))),
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Center(
              child: Column(children: [
            Text(
                "Вы направляетесь в сторону конечной: ${_route.stations[_route.stations.length - 1].name}",
                style: TextStyle(fontSize: 25, color: Colors.white),
                textAlign: TextAlign.center),
            SizedBox(
              height: 30,
            ),
            Text("Ваша следующая остановка: ${_route.stations[index].name}",
                style: TextStyle(fontSize: 25, color: Colors.white),
                textAlign: TextAlign.center),
          ]))),
      Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
              child: Center(
                  child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          _getToTheMap(MapData(_route, index));
                        });
                      },
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.green[500],
                      child: Container(
                          alignment: Alignment.center,
                          width: 200,
                          height: 65,
                          child: Text(
                            "В путь!",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ))))))
    ]));
  }

  Widget _stationsList(List<Station> stations) {
    return SafeArea(
        child: Column(children: [
      Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Center(
              child: Text(
            "Выберите остановку, к которой вы прямо сейчас поедете",
            style: TextStyle(fontSize: 20, color: Colors.white),
            textAlign: TextAlign.center,
          ))),
      Flexible(
          child: ListView.builder(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        itemCount: stations.length,
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
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
