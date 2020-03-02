import 'package:flutter/material.dart';

import 'Managers/network_manager.dart';

class RouteMenu extends StatefulWidget {
  @override
  RouteMenuState createState() {
    return RouteMenuState();
  }
}

class RouteMenuState extends State {
  List<String> _stations;
  static Widget _stationsWidget;
  static Widget _directionWidget;
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    _stationsWidget,
    _directionWidget,
  ];

  void initState() {
    _loadStations();
  }

  void _loadStations() {
    setState(() {
      _stationsWidget = _loadWidget();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("19"),
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
        selectedItemColor: Colors.amber[800],
        // onTap: _onItemTapped,
      ),
    );
  }

  Widget _loadWidget() {
    return SizedBox(
      child: CircularProgressIndicator(),
      width: 60,
      height: 60,
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
        child: Text("Попробовать ещё"),
      )
    ])));
  }

  Widget _filledDirrectionWidget(List<String> stations) {
    return Text("${stations[0]} ${stations[stations.length - 1]}");
  }

  Widget _filledsStationsWidget(List<String> stations) {
    return ListView.builder(
      itemCount: stations.length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
          title: Text(stations[index], style: TextStyle(color: Colors.black)),
          onTap: () => {_onItemTapped(1)},
        ));
      },
    );
  }
}
