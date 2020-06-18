import 'package:flutter_app/Models/station.dart';

class RouteData {
  final String id;
  final String routeName;
  final String busNumber;
  final List<Station> stations;

  RouteData(this.id, this.routeName, this.busNumber, this.stations);

  factory RouteData.fromJson(dynamic json) {
    return RouteData(
        json['id'], json['routeName'], json['busNumber'], parseStations(json));
  }

  static List<Station> parseStations(stationJSON) {
    var list = stationJSON['stops'] as List;
    List<Station> stationsList =
        list.map((data) => Station.fromJson(data)).toList();
    return stationsList;
  }
}
