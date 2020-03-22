import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/Models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/passanger.dart';

class MapsPage extends StatefulWidget {
  MapData _mapData;
  MapsPage(this._mapData);
  @override
  _MapsPageState createState() => _MapsPageState(_mapData);
}

class _MapsPageState extends State {
  _MapsPageState(this._mapData);

  Map<String, Marker> _markers = Map();
  MapData _mapData;
  GoogleMapController _controller;
  Timer mapUpdate;
  BitmapDescriptor driverIcon;

  @override
  void initState() {
    _getDriverIcon();
    _getRoutPoint();
    _getLocation();
  }

  void _getDriverIcon() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/driver_icon.png');
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(52.093877, 23.731953),
    zoom: 10.5,
  );

  Future<double> _getDistanceBetwen(Position position, Station station) async {
    return await Geolocator().distanceBetween(position.latitude,
        position.longitude, station.latLng.latitude, station.latLng.longitude);
  }

  void _addStation(Station station) {
    _markers[station.name] = Marker(
        markerId: MarkerId(station.name),
        position: LatLng(station.latLng.latitude, station.latLng.longitude),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
  }

  void _getRoutPoint() {
    for (var item in _mapData.stations) {
      _addStation(item);
    }
  }

  void _updateYourMarker(Position newLocalData) {
    if (mapUpdate != null && _controller != null) {
      LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
      this.setState(() {
        _markers["You"] = Marker(
          markerId: MarkerId("You"),
          position: latlng,
          icon: driverIcon,
          zIndex: 2,
          flat: true,
        );
      });
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(newLocalData.latitude, newLocalData.longitude),
          zoom: 18.00)));
    }
  }

  void _toNextStation(double distance) {
    setState(() {
      _mapData.setDistance(distance.round());
      _mapData.setNextStation();
    });
  }

  void _setNextStationImediatly() {
    if (!_mapData.isRouteEnd) {
      setState(() {
        _mapData.setNextStationImediatly();
      });
    } else {
      debugPrint("Route is over - reverse or chouse another?");
    }
  }

  void _getLocation() {
    mapUpdate = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        if (_controller != null) {
          if (!_mapData.isRouteEnd) {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            double distance =
                await _getDistanceBetwen(position, _mapData.nextStation);
            _toNextStation(distance);
            _updateYourMarker(position);
          } else
            debugPrint("Route is over - reverse or chouse another?");
        }
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          debugPrint("Permission Denied");
        }
      }
    });
  }

  @override
  void dispose() {
    mapUpdate.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Flexible(
          child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      )),
      Flexible(
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Column(children: [
                stationDataItemWidget(
                    "Направляйтесь к остановке: ", _mapData.nextStation.name),
                SizedBox(height: 10),
                stationDataItemWidget(
                    "Расстояние: ", _mapData.getDistanceAsString()),
                SizedBox(height: 10),
                stationDataItemWidget("Выйдет пассажиров: ", ""),
                SizedBox(height: 10),
                stationDataItemWidget("Зайдёт пассажиров: ", ""),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: RaisedButton(
                      onPressed: () {
                        if (!_mapData.isRouteEnd) {
                          _setNextStationImediatly();
                        }
                      },
                      child: Text("Следующая остановка"),
                    ))
              ])))
    ]));
  }

  TextStyle stationData() {
    return TextStyle(fontSize: 18);
  }

  Widget stationDataItemWidget(String leftSide, String rightSide) {
    return Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
            child: Row(children: [
          Text(leftSide, style: stationData()),
          Text(rightSide, style: stationData())
        ])));
  }
}

class MapData {
  Station nextStation;
  int _nextStationIndex;
  bool isRouteEnd = false;
  int _distance;
  DriverCar driverCar = new DriverCar();
  List<Station> stations;

  void setNextStation() {
    if (nextStation == null) {
      nextStation = _getNextStation();
      return;
    }
    if (_isCloseDistance()) {
      nextStation = _getNextStation();
      if (nextStation == null) {
        isRouteEnd = true;
        nextStation = stations[_nextStationIndex];
      }
    }
  }

  void setNextStationImediatly() {
    nextStation = _getNextStation();
    _distance = null;
    if (nextStation == null) {
      isRouteEnd = true;
      nextStation = stations[_nextStationIndex];
    }
  }

  Station _getNextStation() {
    int index = _nextStationIndex + 1;
    if (_isRightIndex(index)) {
      _nextStationIndex = index;
      return stations[index];
    }
    return null;
  }

  bool _isRightIndex(int index) {
    if (index >= 0 && index < stations.length) return true;
    return false;
  }

  bool _isCloseDistance() {
    if (_distance < 50) return true;
    return false;
  }

  void setDistance(int dist) {
    _distance = dist;
  }

  String getDistanceAsString() {
    if (_distance == null)
      return "вычисляется...";
    else
      return "${_distance} м";
  }

  MapData(RouteData route, int nextStationIndex) {
    this._nextStationIndex = nextStationIndex;
    stations = route.stations;
    nextStation = stations[this._nextStationIndex];
  }
}

class DriverCar {
  List<Passanger> _passangers;

  DriverCar() {
    _passangers = new List();
  }

  void addPassanger(Passanger passanger) {
    _passangers.add(passanger);
  }

  void removePassanger(Station station) {
    for (Passanger passanger in _passangers) {
      if (passanger.endStation.index == station.index)
        _passangers.remove(passanger);
    }
    NetworkManager.updateStation();
  }
}
