// import 'package:flutter/material.dart';
// import 'package:flutter_app/prefs_manager.dart';

// class FirstScreen extends StatefulWidget {
//   @override
//   FirstScreenState createState() {
//     return FirstScreenState();
//   }
// }

// class FirstScreenState extends State<FirstScreen> {
//   Widget _child;

//   @override
//   void initState(){
//     String user = null;
//     if (user == "" || user == null) {
//       _child = Greatings();
//     } else
//       _child = Text(" Приветствую " + user);
//       print(user);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(child: SafeArea(child: _child));
//   }
// }






// class RouteList extends StatefulWidget {
//   @override
//   RouteListState createState() {
//     return RouteListState();
//   }
// }

// class RouteListState extends State<RouteList> {
//   List<Text> texts = List();
//   @override
//   void initState() {
//     for (int i = 0; i < 69; i++)
//       texts.add(Text(i.toString(), style: TextStyle(color: Colors.black)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: ListWheelScrollView(itemExtent: 50, children: texts));
//   }
// }
