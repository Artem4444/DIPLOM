import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app/Models/user.dart';
import 'package:http/http.dart' as http;

import 'app_repository.dart';

class NetworkManager {
  static var _internetConectionEvent;
  static bool isConected;
  static Function onConectionLost;

  static Future<List<RouteData>> getRoutes() async {
    try {
      final response = await http.get('http://10.0.2.2:8080/api/routes/');
      String jsonString = response.body;
      var list = jsonDecode(jsonString)['routes'] as List;
      List<RouteData> routes =
          list.map((data) => RouteData.fromJson(data)).toList();
      return routes;
    } on Exception {
      throwCustomException();
    }
  }

  static Future<http.Response> login(User user) async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/drivers/login?mobile=${user.mobileNumber.replaceFirst('+', '')}&password=${user.password}";
      final response = await http.get(adress);
      return response;
    } on Exception {
      throwCustomException();
    }
  }

  static Future<http.Response> registration(User user) async {
    try {
      String jsonUser = jsonEncode(user);
      String adress = "http://10.0.2.2:8080/api/drivers/login?driver=$jsonUser";
      final response = await http.post(adress);
      return response;
    } on Exception {
      throwCustomException();
    }
  }

  static Future<int> getWaitingPassangers(int stationId) async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/stations/getstationpassangers?stationid=$stationId";
      final response = await http.get(adress);
      return int.parse(response.body);
    } on Exception {
      throwCustomException();
    }
  }

  static Future<int> getReadyPassangers() async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/stations/getcarpassangers?driverid=${AppRepository.localUser.id}";
      final response = await http.get(adress);
      return int.parse(response.body);
    } on Exception {
      throwCustomException();
    }
  }

  static sendDriverData(double lat, double lng) async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/drivers/updatedriverposition?lat=${lat}&lng${lng}";
      final response = await http.post(adress);
    } on Exception {
      throwCustomException();
    }
  }

  static startDriving(String routeId) async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/drivers/startdriving?routeid=${routeId}&driverid${AppRepository.localUser.id}";
      final response = await http.post(adress);
    } on Exception {
      throwCustomException();
    }
  }

  static endDriving(String routeId) async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/drivers/enddriving?routeid=${routeId}&driverid${AppRepository.localUser.id}";
      final response = await http.delete(adress);
    } on Exception {
      throwCustomException();
    }
  }

  static void updateStation(String stationId) async {
    try {
      String adress =
          "http://10.0.2.2:8080/api/stations/updatestation?stationid=${stationId}&driverid${AppRepository.localUser.id}";
      final response = await http.put(adress);
    } on Exception {
      throwCustomException();
    }
  }

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

  static void throwCustomException() {
    throw new NotReachServerException();
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
      key: ValueKey<String>("Loading"),
        child: SizedBox(
      width: 60,
      height: 60,
      child: CircularProgressIndicator(),
    ));
  }
}

class NotReachServerException implements Exception {}
