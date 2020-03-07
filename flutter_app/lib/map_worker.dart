import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State {
  Map<String, Marker> _markers = Map();
  GoogleMapController _controller;
  Timer mapUpdate;
  @override
  void initState() {
    getRoutPoint();
    startGetLocation();
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(52.136473, 23.712127),
    zoom: 14.5,
  );

  void showNextTarget() {
    setState(() {
      _markers.clear();
    });
  }

  void getRoutPoint() {
    _markers["Вересковая 10"] = Marker(
        markerId: MarkerId("Вересковая 10"),
        position: LatLng(52.136473, 23.712127),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
    _markers["Вересковая 11"] = Marker(
        markerId: MarkerId("Вересковая 11"),
        position: LatLng(52.138241, 23.711912),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
    _markers["Крайняя"] = Marker(
        markerId: MarkerId("Крайняя"),
        position: LatLng(52.140410, 23.705616),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
    _markers["Возера"] = Marker(
        markerId: MarkerId("Возера"),
        position: LatLng(52.142916, 23.706156),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
    _markers["Калиннавая"] = Marker(
        markerId: MarkerId("Калиннавая"),
        position: LatLng(52.141592, 23.714120),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
    _markers["переулок Калиннавый"] = Marker(
        markerId: MarkerId("переулок Калиннавый"),
        position: LatLng(52.141066, 23.719452),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
    _markers["Изумрудная"] = Marker(
        markerId: MarkerId("Изумрудная"),
        position: LatLng(52.137555, 23.717920),
        rotation: 0,
        icon: BitmapDescriptor.defaultMarkerWithHue(0));
  }

  void updateYourMarker(Position newLocalData) {
    if (mapUpdate != null) {
      LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
      this.setState(() {
        _markers["You"] = Marker(
          markerId: MarkerId("You"),
          position: latlng,
          rotation: newLocalData.heading,
          icon: BitmapDescriptor.defaultMarker,
          // icon: BitmapDescriptor.fromAsset("images/driver_icon.png"),
          zIndex: 2,
          flat: true,
        );
      });
    }
  }

  void startGetLocation() {
    mapUpdate = Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
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
      Flexible(child: Container(child: Text("SAS")))
    ]));
  }
}

class MapData{
  List<String> stations = List<String>();
}