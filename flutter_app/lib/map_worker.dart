import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/Models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  Widget bottomWidget;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(52.093877, 23.731953),
    zoom: 10.5,
  );

  @override
  void initState() {
    _getDriverIcon();
    _getRoutPoint();
    _updateData();
    _setWayWidget();
  }

  void _getDriverIcon() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/driver_icon.png');
  }

  void _addStation(Station station) {
    _markers[station.name] = Marker(
        markerId: MarkerId(station.name),
        infoWindow: InfoWindow(title: station.name),
        position: LatLng(station.latLng.latitude, station.latLng.longitude),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
  }

  void _getRoutPoint() {
    for (var item in _mapData.stations) {
      _addStation(item);
    }
  }

  void _setWayWidget() {
    setState(() {
      bottomWidget = _wayWidget();
    });
  }

  void _setEndWayWidget() {
    setState(() {
      bottomWidget = _endWayWidget();
    });
  }

  void _setSendDataWidget() {
    setState(() {
      bottomWidget = _sendDataWidget();
    });
  }

  void _updateYourMarker(Position newPosition) {
    if (mapUpdate != null && _controller != null) {
      LatLng latlng = LatLng(newPosition.latitude, newPosition.longitude);
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
          target: LatLng(newPosition.latitude, newPosition.longitude),
          zoom: 17.00)));
    }
  }

  void _nextStationButtonOnclick() {
    if (!_mapData.isRouteEnd) {
      setState(() {
        _mapData.setNextStationImediatly();
        _setWayWidget();
      });
    } else {
      _setEndWayWidget();
    }
  }

  void _updateData() {
    mapUpdate = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        if (_controller != null) {
          if (!_mapData.isRouteEnd) {
            await _mapData.getYourPosition();
            await _mapData.getDistance();
            if (_mapData.isCloseDistance()) {
              _setSendDataWidget();
              _mapData.toNextStation();
            } else {
              _setWayWidget();
              _updateYourMarker(_mapData.position);
            }
          } else
            _setEndWayWidget();
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
        body: Container(
            color: Colors.blue[300],
            child: Column(children: [
              Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 2, color: Colors.black))),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: initialLocation,
                        markers: Set<Marker>.of(_markers.values),
                        onMapCreated: (GoogleMapController controller) {
                          _controller = controller;
                        },
                      ))),
              bottomWidget
            ])));
  }

  TextStyle _stationData() {
    return TextStyle(fontSize: 20, color: Colors.white);
  }

  Widget _wayWidget() {
    return Flexible(
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(children: [
              _stationDataItemWidget(
                  "Направляйтесь к остановке: ", _mapData.nextStation.name),
              SizedBox(height: 20),
              _stationDataItemWidget(
                  "Расстояние: ", _mapData.getDistanceAsString()),
              SizedBox(height: 20),
              _stationDataItemWidget(
                  "Выйдет пассажиров: ", _mapData.getPassangerAsString(null)),
              SizedBox(height: 20),
              _stationDataItemWidget(
                  "Зайдёт пассажиров: ", _mapData.getPassangerAsString(null)),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      width: 215,
                      child: RaisedButton(
                        color: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(width: 1, color: Colors.black),
                        ),
                        onPressed: () {
                          if (!_mapData.isRouteEnd) {
                            _nextStationButtonOnclick();
                          }
                        },
                        child: Row(children: [
                          Text("Следующая остановка ",
                              style: TextStyle(color: Colors.white)),
                          Expanded(
                              child: Icon(Icons.forward, color: Colors.white)),
                        ]),
                      )))
            ])));
  }

  Widget _endWayWidget() {
    return Flexible(
        child: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text(
                "Вы прибыли на конечную!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35, color: Colors.white),
              )),
          RaisedButton(
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(width: 1, color: Colors.black),
            ),
            onPressed: () {
              if (_mapData.isRouteEnd) {
                print("to menu");
              }
            },
            child: Text("В меню выбора маршрутов",
                style: TextStyle(color: Colors.white)),
          )
        ]))));
  }

  Widget _sendDataWidget() {
    return Flexible(
        child: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: Text(
              "Судя по всему вы близко к остановке ${_mapData.nextStation.name}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35, color: Colors.white),
            ),
          ),
          Text(
            "Отправка данных...",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ]))));
  }

  Widget _stationDataItemWidget(String leftSide, String rightSide) {
    return Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
            child: Row(children: [
          Text(leftSide, style: _stationData()),
          Text(rightSide, style: _stationData())
        ])));
  }
}

class MapData {
  Station nextStation;
  Position position;
  int _nextStationIndex;
  bool isRouteEnd = false;
  double _distance;
  List<Station> stations;

  void toNextStation() {
    nextStation = _getNextStation();
    if (nextStation == null) {
      isRouteEnd = true;
      nextStation = stations[_nextStationIndex];
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

  getYourPosition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getDistance() async {
    _distance = await _getDistanceBetwen(position, nextStation);
  }

  Future<double> _getDistanceBetwen(Position position, Station station) async {
    return await Geolocator().distanceBetween(position.latitude,
        position.longitude, station.latLng.latitude, station.latLng.longitude);
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

  bool isCloseDistance() {
    if (_distance < 50) return true;
    return false;
  }

  String getDistanceAsString() {
    if (_distance == null)
      return "обновлениe...";
    else
      return "${_distance.round()} м";
  }

  String getPassangerAsString(int passangerCount) {
    if (passangerCount == null)
      return "обновлениe...";
    else
      return passangerCount.toString();
  }

  MapData(RouteData route, int nextStationIndex) {
    this._nextStationIndex = nextStationIndex;
    stations = route.stations;
    nextStation = stations[this._nextStationIndex];
  }
}
