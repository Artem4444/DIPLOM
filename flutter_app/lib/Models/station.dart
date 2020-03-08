import 'package:flutter_app/Models/passanger.dart';

class Station {
  int index;
  String name;
  double latitude;
  double longitude;
  List<Passanger> passangers;

Station(this.index, this.name, this.latitude, this.longitude, this.passangers);

}
