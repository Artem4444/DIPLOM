class RouteData {
  final int routeNumber;
  final String startStation;
  final String endStation;

  RouteData(this.routeNumber, this.startStation, this.endStation);

  factory RouteData.fromJson(dynamic json) {
    return RouteData(
        json['routenumber'], json['startstation'], json['endstation']);
  }
}

class RouteMenuData {
  String routeNumber;
  int currentStationIndex;
  int endStationIndex;
  RouteMenuData(){
    currentStationIndex = 0;
    endStationIndex = 0;
  }
}


