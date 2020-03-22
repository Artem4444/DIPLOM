import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/passanger.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter/services.dart' show rootBundle;

class NetworkManager {
  static Future<String> _loadAsRoutesAsset() async {
    return await rootBundle.loadString('assets/fakeData/routes.json');
  }

  static Future<List<RouteData>> readRoutes() async {
    String jsonString = await _loadAsRoutesAsset();
    var list = jsonDecode(jsonString)['routes'] as List;
    List<RouteData> routes =
        list.map((data) => RouteData.fromJson(data)).toList();
    return routes;
  }

  static Future<List<Passanger>> getPassenger() {}

  static void updateStation() {}

  static Widget loadWidget() {
    return Center(
        child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ));
  }
}
