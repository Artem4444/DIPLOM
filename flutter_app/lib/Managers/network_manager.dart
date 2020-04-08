import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/Models/route.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app/Models/user.dart';
import 'package:http/http.dart' as http;

class NetworkManager {
  static var _internetConectionEvent;
  static bool isConected;
  static Function onConectionLost;



// Future<Album> fetchAlbum() async {
//   final response = await http.get('https://jsonplaceholder.typicode.com/albums/1');

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     return Album.fromJson(json.decode(response.body));
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load album');
//   }
// }

//  var client = createHttpClient();
//       client.get(new Uri.http("locahost:8000", "/category"));

// final response = await http.get('http://localhost:8080/api/routes/');
  //String jsonString = response.body;
//http://127.0.0.1:8080/

  // static Future<List<RouteData>> getRoutes() async {
  //   String jsonString = await _loadAsRoutesAsset();
  //    print(jsonString);
  //   var list = jsonDecode(jsonString)['routes'] as List;
  //   List<RouteData> routes =
  //       list.map((data) => RouteData.fromJson(data)).toList();
  //   return routes;
  // }

  static Future<List<RouteData>> getRoutes() async {
    final response = await http.get('http://10.0.2.2:8080/api/routes/');
    String jsonString = response.body;
    var list = jsonDecode(jsonString)['routes'] as List;
    List<RouteData> routes =
        list.map((data) => RouteData.fromJson(data)).toList();
    return routes;
  }

  static Future<http.Response> login(User user) async {
    String adress =
        "http://10.0.2.2:8080/api/drivers/login?mobile=${user.mobileNumber.replaceFirst('+','')}&password=${user.password}";
    final response = await http.get(adress);
    return response;
  }

  static Future<http.Response> registration(User user)async{
   String jsonUser = jsonEncode(user);
   String adress = "http://10.0.2.2:8080/api/drivers/login?driver=$jsonUser";
    final response = await http.post(adress);
   return response;
  }

  static Future<int> getWaitingPassangers(int stationId) async {
    String adress =
        "http://10.0.2.2:8080/api/stations/getstationpassangers?stationid=$stationId";
    final response = await http.get(adress);
    return int.parse(response.body);
  }

  static Future<int> getReadyPassangers() async {
    String adress =
        "http://10.0.2.2:8080/api/stations/getcarpassangers?driverid=${0}";
    final response = await http.get(adress);
    return int.parse(response.body);
  }

  static void updateStation(int stationId) async {}

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
