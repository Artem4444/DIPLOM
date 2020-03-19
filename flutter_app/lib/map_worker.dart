import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    _setMapData();
    _getDriverIcon();
    getRoutPoint();
    getLocation();
  }

  void _getDriverIcon() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/driver_icon.png');
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(52.093877, 23.731953),
    zoom: 10.5,
  );

  void _setMapData() {
    _mapData.setNextStation();
  }

  void showNextTarget() {
    setState(() {
      _markers.clear();
    });
  }

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

  void getRoutPoint() {
    for (var item in _mapData.stations) {
      _addStation(item);
    }
  }

  void updateYourMarker(Position newLocalData) {
    if (mapUpdate != null) {
      LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
      this.setState(() {
        _markers["You"] = Marker(
          markerId: MarkerId("You"),
          position: latlng,
          rotation: newLocalData.heading,
          icon: driverIcon,
          zIndex: 2,
          flat: true,
        );
      });
    }
  }

  void getLocation() {
    mapUpdate = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        if (_controller != null) {
          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          double distance =
              await _getDistanceBetwen(position, _mapData.nextStation);
          setState(() {
            _mapData.distance = distance.round();
            _mapData.setNextStation();
          });
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 18.00)));
          updateYourMarker(position);
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
                stationDataItemWidget("Расстояние: ", "${_mapData.distance} м"),
                SizedBox(height: 10),
                stationDataItemWidget("Выйдет пассажиров: ", ""),
                SizedBox(height: 10),
                stationDataItemWidget("Зайдёт пассажиров: ", ""),
                SizedBox(height: 10),
                Align(
                    alignment: Alignment.centerLeft,
                    child: RaisedButton(
                      onPressed: () {},
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
  int currentStationIndex;
  int nextStationIndex;
  bool toLastStation;
  bool isRouteEnd = false;
  int distance;
  List<Station> stations = List<Station>();

  void setNextStation() {
    if (nextStation == null) {
      nextStation = _chouseNextStation();
      return;
    }
    if (_isCloseDistance()) {
      nextStation = _chouseNextStation();
      if (nextStation == null) {
        isRouteEnd = true;
        nextStation = stations[currentStationIndex];
      }
    }
  }

  Station _chouseNextStation() {
    int index;
    if (toLastStation)
      index = currentStationIndex + 1;
    else
      index = currentStationIndex - 1;
    if (_isRightIndex(index)) {
      currentStationIndex = index;
      return stations[index];
    }
    return null;
  }

  bool _isRightIndex(int index) {
    if (index >= 0 && index < stations.length) return true;
    return false;
  }

  bool _isCloseDistance() {
    if (distance < 50) return true;
    return false;
  }

  MapData(this.currentStationIndex, this.toLastStation) {
    stations.add(
        new Station("0", "Вересковая 10", LatLng(52.136473, 23.712127), null));
    stations.add(
        new Station("1", "Вересковая 11", LatLng(52.138241, 23.711912), null));
    stations
        .add(new Station("2", "Крайняя", LatLng(52.140410, 23.705616), null));
    stations
        .add(new Station("3", "Возера", LatLng(52.142916, 23.706156), null));
    stations
        .add(new Station("4", "Калинавая", LatLng(52.141592, 23.714120), null));
    stations.add(new Station(
        "5", "переулок Калиннавый", LatLng(52.141066, 23.719452), null));
    stations.add(
        new Station("6", "Изумрудная", LatLng(52.137555, 23.717920), null));
  }
}
