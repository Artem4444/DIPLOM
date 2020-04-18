import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/Managers/network_manager.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter_app/Models/station.dart';
import 'package:flutter_app/Templates/alerts.dart';
import 'package:flutter_app/main_menu.dart';
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
    NetworkManager.startListenConectionState(_setNoInternetWidget);
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

  void _setCloseDistanseWidget(String stationName) async {
    setState(() {
      bottomWidget = _closeDistanseWidget(stationName);
    });
    await _mapData.updateStationOnServer();
  }

  void _setNoInternetWidget() {
    setState(() {
      bottomWidget = Alerts.noInternetWidgetWithoutButton();
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

  void _targetStationButtonOnclick() {
    if (!_mapData.isRouteEnd) {
      setState(() {
        _mapData.settargetStationImediatly();
        _setWayWidget();
      });
    } else {
      _setEndWayWidget();
    }
  }

  void _updateData() {
    mapUpdate = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        if (!NetworkManager.isConected) {
          return;
        }
        if (_controller != null) {
          if (!_mapData.isRouteEnd) {
            await _mapData.getYourPosition();
            await _mapData.getDistance();
            await _mapData.updatePassangers();
            await _mapData.sendData();
            if (_mapData.isCloseDistance()) {
              _setCloseDistanseWidget(_mapData.targetStation.name);
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

  _toMenuButton() async {
    if (_mapData.isRouteEnd) {
      try {
        await NetworkManager.endDriving(_mapData.routeId);
      } on NotReachServerException {
        print("NOT EXECUTE endJourney METHOD!");
      }
      NavigationManager.push(context, MainMenu());
    }
  }

  @override
  void dispose() {
    mapUpdate.cancel();
    NetworkManager.removeConectionListener();
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
              Container(
                  height: 270,
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: bottomWidget))
            ])));
  }

  TextStyle _stationData() {
    return TextStyle(fontSize: 20, color: Colors.white);
  }

  Widget _wayWidget() {
    return Flexible(
        key: ValueKey<String>("Way"),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Column(children: [
              _stationDataItemWidget(
                  "Направляйтесь к остановке: ", _mapData.targetStation.name),
              SizedBox(height: 20),
              _stationDataItemWidget(
                  "Расстояние: ", _mapData.getDistanceAsString()),
              SizedBox(height: 20),
              _stationDataItemWidget(
                  "Выйдет пассажиров: ", _mapData.getReadyPassangerAsString()),
              SizedBox(height: 20),
              _stationDataItemWidget("Зайдёт пассажиров: ",
                  _mapData.getWaitingPassangerAsString()),
              SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      width: 215,
                      child: RaisedButton(
                        color: Colors.orange[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(width: 1, color: Colors.black),
                        ),
                        onPressed: () {
                          if (!_mapData.isRouteEnd) {
                            _targetStationButtonOnclick();
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
    return Container(
        key: ValueKey<String>("EndWayWidget"),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              _toMenuButton();
            },
            child: Text("В меню выбора маршрутов",
                style: TextStyle(color: Colors.white)),
          )
        ])));
  }

  Widget _closeDistanseWidget(String stationName) {
    return Container(
        key: ValueKey<String>("CloseDistance"),
        child: Container(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Text(
                  "Судя по всему вы близко к остановке $stationName",
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
  int _targetStationIndex;
  int _waitingPassangerCount;
  int _readyPassangerCount;
  bool isRouteEnd = false;
  double _distance;
  String routeId;
  Station targetStation;
  Position position;
  List<Station> stations;

  void toNextStation() {
    targetStation = _getNextStation();
    if (targetStation == null) {
      isRouteEnd = true;
      targetStation = stations[_targetStationIndex];
    }
  }

  void settargetStationImediatly() async{
    await updateStationOnServer();
    targetStation = _getNextStation();
    _distance = null;
    if (targetStation == null) {
      isRouteEnd = true;
      targetStation = stations[_targetStationIndex];
    }
  }

  updatePassangers() async {
    try {
      _waitingPassangerCount = await NetworkManager.getWaitingPassangers(0);
      _readyPassangerCount = await NetworkManager.getReadyPassangers();
    } on NotReachServerException {
      print("NOT UPDATE PASSANGERS!");
    }
  }

  updateStationOnServer() async {
    try {
      await NetworkManager.updateStation(targetStation.index);
    } on NotReachServerException {
      print("NOT UPDATE PASSANGERS!");
    }
  }

  sendData() async {
    try {
      await NetworkManager.sendDriverData(
          position.latitude, position.longitude);
    } on NotReachServerException {
      print("NOT SEND DATA!");
    }
  }

  getYourPosition() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getDistance() async {
    _distance = await _getDistanceBetwen(position, targetStation);
  }

  Future<double> _getDistanceBetwen(Position position, Station station) async {
    return await Geolocator().distanceBetween(position.latitude,
        position.longitude, station.latLng.latitude, station.latLng.longitude);
  }

  Station _getNextStation() {
    int index = _targetStationIndex + 1;
    if (_isRightIndex(index)) {
      _targetStationIndex = index;
      return stations[index];
    }
    return null;
  }

  bool _isRightIndex(int index) {
    if (index >= 0 && index < stations.length) return true;
    return false;
  }

  bool isCloseDistance() {
    if (_distance == null) return false;
    if (_distance < 50) return true;
    return false;
  }

  String getDistanceAsString() {
    if (_distance == null)
      return "обновлениe...";
    else
      return "${_distance.round()} м";
  }

  String getWaitingPassangerAsString() {
    if (_waitingPassangerCount == null)
      return "обновлениe...";
    else
      return _waitingPassangerCount.toString();
  }

  String getReadyPassangerAsString() {
    if (_readyPassangerCount == null)
      return "обновлениe...";
    else
      return _readyPassangerCount.toString();
  }

  MapData(RouteData route, int targetStationIndex) {
    this._targetStationIndex = targetStationIndex;
    stations = route.stations;
    routeId = route.id;
    targetStation = stations[this._targetStationIndex];
  }
}
