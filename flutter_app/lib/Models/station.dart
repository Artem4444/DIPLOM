import 'package:flutter_app/Models/passanger.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  String index;
  String name;
  LatLng latLng;
  List<Passanger> passangers;

  Station(this.index, this.name, this.latLng, this.passangers);
  factory Station.fromJson(dynamic json) {
    return Station("0", json['stopName'], parseLatLng(json), null);
  }

    static LatLng parseLatLng(latLngJSON) {
    var latLng = latLngJSON['latLng'];
    return LatLng(latLng['latititude'], latLng['longitude']);
  }
}
