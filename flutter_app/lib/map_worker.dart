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
    startGetLocation();
  }

  void _getDriverIcon() async {
    driverIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/driver_icon.png');
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(52.136473, 23.712127),
    zoom: 14.5,
  );

  void _setMapData() {
    _mapData.setCurrentTarget();
  }

  void showNextTarget() {
    setState(() {
      _markers.clear();
    });
  }

  Future<double> _getDistanceBetwen(Position position, Station station) async {
    return await Geolocator().distanceBetween(position.latitude,
        position.longitude, station.latitude, station.longitude);
  }

  void _addStation(Station station) {
    _markers[station.name] = Marker(
        markerId: MarkerId(station.name),
        position: LatLng(station.latitude, station.longitude),
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

  void startGetLocation() {
    mapUpdate = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        if (_controller != null) {
          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          double distance =
              await _getDistanceBetwen(position, _mapData.nextStation);
          setState(() {
            _mapData.distance = distance;
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
              child: Column(children: [
        Row(children: [
          Text("Направляйтесь к остановке: "),
          Text(_mapData.nextStation.name)
        ]),
        Row(children: [Text("Расстояние"), Text(_mapData.distance.toString())]),
        Row(children: [Text("Выйдет пассажиров: "), Text("")]),
        Row(children: [Text("Зайдёт пассажиров: "), Text("")]),
        RaisedButton(
          onPressed: () {},
          child: Text("Ручной ввод"),
        )
      ])))
    ]));
  }
}

class MapData {
  Station nextStation;
  int currentStationIndex;
  int nextStationIndex;
  bool isLastStation;
  double distance;
  List<Station> stations = List<Station>();

  void setCurrentTarget() {
    nextStation = stations[currentStationIndex];
  }

  MapData(this.currentStationIndex, this.isLastStation) {
    stations.add(new Station(0, "Вересковая 10", 52.136473, 23.712127, null));
    stations.add(new Station(1, "Вересковая 11", 52.138241, 23.711912, null));
    stations.add(new Station(2, "Крайняя", 52.140410, 23.705616, null));
    stations.add(new Station(3, "Возера", 52.142916, 23.706156, null));
    stations.add(new Station(4, "Калинавая", 52.141592, 23.714120, null));
    stations
        .add(new Station(5, "переулок Калиннавый", 52.141066, 23.719452, null));
    stations.add(new Station(6, "Изумрудная", 52.137555, 23.717920, null));
  }
}
