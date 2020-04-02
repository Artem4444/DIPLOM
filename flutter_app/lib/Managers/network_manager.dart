import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:connectivity/connectivity.dart';

class NetworkManager {
  static var _internetConectionEvent;
  static bool isConected;
  static Function onConectionLost;
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

  static Future<int> getPassengerCountFromStation() {}
  static Future<int> updatePassangerCountInCar() {}

  static void updateStation() {}

  static void startListenConectionState(Function onConectionLostHandler) {
    onConectionLost = onConectionLostHandler;
    _internetConectionEvent = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      print("Connection Status has Changed");
      isConected = await getConectionStatus();
      if (!isConected) onConectionLost();
    });
  }

  static void removeConectionListener() {
    _internetConectionEvent.cancel();
    onConectionLost = null;
  }

  static Future<bool> getConectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return true;
    } else {
      print("Unable to connect. Please Check Internet Connection");
      return false;
    }
  }

  static Widget loadWidget() {
    return Center(
        child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ));
  }
}
