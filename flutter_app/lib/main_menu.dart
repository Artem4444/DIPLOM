import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Authorization/registration.dart';
import 'package:flutter_app/Managers/navigation_manager.dart';
import 'package:flutter_app/route_page.dart';

class MainMenu extends StatefulWidget {
  @override
  MainMenuState createState() {
    return MainMenuState();
  }
}

class MainMenuState extends State<MainMenu> {
  List<Widget> texts = List();

  @override
  void initState() {
    for (int i = 0; i < 69; i++) texts.add(ListItem());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Container(
                    child: ListView(
              itemExtent: 70,
               children: texts,
            )))));
  }
}

class ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
    Card(child:
     ListTile(
            title: Text("hehe", style: TextStyle(color: Colors.black)),
            onTap: () => {
              NavigationManager.push(context, RoutePage()),
            print("HEHEHH")
            }));
  }
}
