class RouteData {
  final String routenumber;
  final String startStation;
  final String endStation;

  RouteData(this.routenumber, this.startStation, this.endStation);

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
