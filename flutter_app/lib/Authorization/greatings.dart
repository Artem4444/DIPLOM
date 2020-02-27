import 'package:flutter/material.dart';
import 'package:flutter_app/prefs_manager.dart';

class Greatings extends StatefulWidget {
  @override
  GreatingsState createState() {
    return GreatingsState("HEHEH");
  }
}

class GreatingsState extends State<Greatings> {
  final String _userName;

  GreatingsState(this._userName);

  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body:
            SafeArea(child:
             Container(
                child: Center(
                    child: new Column(children: [
              new Text("Добро пожаловать! " + _userName,
                  textScaleFactor: 3, textAlign: TextAlign.center)
            ]))))));
  }
}
