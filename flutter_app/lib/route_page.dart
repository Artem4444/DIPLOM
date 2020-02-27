import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/map_worker.dart';

import 'Managers/navigation_manager.dart';

class RoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Container(
              child: RaisedButton(
                  onPressed: () => {NavigationManager.push(context, MyApp())},
                  child: Text("TO THE MAP")
                  ),
            ))));
  }
}
