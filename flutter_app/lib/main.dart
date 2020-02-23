import 'package:flutter/material.dart';
import 'authorization.dart';
import 'network_manager.dart';
//void main() => runApp(MyApp());
void main(){
   runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(backgroundColor: Colors.white, body: Greatings())));
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Container(
//             child: Center(
//                 child: Column(children: [
//           Text(
//             "Welcome!",
//             style: TextStyle(fontSize: 45, color: Colors.black),
//           ),
//           MyAppButton(LoginButton("Login", Colors.blueAccent)),
//           Text(
//             "or",
//             style: TextStyle(fontSize: 25, color: Colors.black),
//           ),
//           MyAppButton(RegistrationButton("Registration", Colors.greenAccent))
//         ], mainAxisAlignment: MainAxisAlignment.center))));
//   }
// }

// class MyAppButton extends StatelessWidget {
//   final Button _button;
//   MyAppButton(this._button);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 50,
//         margin: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//             color: _button._color, borderRadius: BorderRadius.circular(15)),
//         child: Center(
//           child: FlatButton(
//               onPressed: () => _button.onClick(context),
//               child: new Text(
//                 _button._label,
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               )),
//         ));
//   }
// }

// abstract class Button {
//   final String _label;
//   final Color _color;
//   Button(this._label, this._color);
//   void onClick(BuildContext context);
// }

// class LoginButton extends Button {
//   LoginButton(String label, Color color) : super(label, color);
//   void onClick(BuildContext context) {
//     print("HAHA");
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SecondRoute()),
//     );
//   }
// }

// class RegistrationButton extends Button {
//   RegistrationButton(String label, Color color) : super(label, color);

//   void onClick(BuildContext context) {
//     print("UHUHUHUH");
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SecondRoute()),
//     );
//   }
// }

// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Second Route"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }
