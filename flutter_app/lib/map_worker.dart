import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Map Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Marker> _markers = Map();
  GoogleMapController _controller;
  
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
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      _markers["You"] = Marker(
        markerId: MarkerId("You"),
        position: latlng,
        rotation: newLocalData.heading,
        icon: BitmapDescriptor.defaultMarker,
        zIndex: 2,
        flat: true,
      );
    });
  }

  void startGetLocation() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        print("TRACKING");
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      bottomNavigationBar: Row(children: [
        RaisedButton(
            onPressed: () {
              showNextTarget();
            },
            child: Icon(Icons.location_city)),
        RaisedButton(
            onPressed: () {
            //  getCurrentLocation();
            },
            child: Icon(Icons.location_searching))
      ]),
    );
  }
}
