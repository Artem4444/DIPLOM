import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_app/Models/station.dart';

class NetworkManager {
  static Future<String> _loadAsRoutesAsset() async {
    return await rootBundle.loadString('assets/fakeData/routes.json');
  }

  // static Future<String> _loadAsStationAsset() async {
  //   return await rootBundle.loadString('assets/fakeData/stations.json');
  // }

  static Future<List<RouteData>> readRoutes() async {
    String jsonString = await _loadAsRoutesAsset();
    var list = jsonDecode(jsonString)['routes'] as List;
    List<RouteData> routes = list.map((data) => RouteData.fromJson(data)).toList();
    return routes;
  }

  // static Future<List<String>> readStations() async {
  //   String jsonStations = await _loadAsStationAsset();
  //   var objJson = jsonDecode(jsonStations);
  //   List<String> stations = objJson != null ? List.from(objJson) : null;
  //   print(stations);
  //   return stations;
  // }

  static Widget loadWidget() {
    return Center(
        child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ));
  }
}
