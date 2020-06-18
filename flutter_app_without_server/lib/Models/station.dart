import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  String index;
  String name;
  LatLng latLng;

  Station(this.index, this.name, this.latLng);
  factory Station.fromJson(dynamic json) {
    return Station("0", json['stopName'], parseLatLng(json));
  }

    static LatLng parseLatLng(latLngJSON) {
    var latLng = latLngJSON['latLng'];
    return LatLng(latLng['latititude'], latLng['longitude']);
  }
}
