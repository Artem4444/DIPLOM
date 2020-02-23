import 'package:flutter/material.dart';
import 'package:flutter_app/prefs_manager.dart';

class Greatings extends StatefulWidget {
  @override
  GreatingsState createState() {
    return GreatingsState();
  }
}

class GreatingsState extends State<Greatings> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: new Column(children: [
      new Text('Добро пожаловать!',
          textScaleFactor: 3, textAlign: TextAlign.center),
      new Row(children: [
        new FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationForm()),
            );
          },
          child: Text('Регистрация'),
          color: Colors.grey,
          textColor: Colors.white,
        ),
        new FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegistrationForm()),
            );
          },
          child: Text('В меню'),
          color: Colors.grey,
          textColor: Colors.white,
        ),
        new FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RouteList()),
            );
          },
          child: Text('Вход'),
          color: Colors.grey,
          textColor: Colors.white,
        )
      ], mainAxisAlignment: MainAxisAlignment.center),
    ], mainAxisAlignment: MainAxisAlignment.center)));
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  RegistrationFormState createState() {
    return RegistrationFormState();
  }
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Имя",
                                icon: Icon(Icons.person)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Введите коректное имя!";
                              }
                              if (value.contains(RegExp("\d\W"))) //не работает
                                return "В этом поле должны быть тольк буквы!";
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Фамилия",
                                icon: Icon(Icons.person)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Введите коректную фамилию!';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Телефонный номер",
                                icon: Icon(Icons.person)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Введите коректный номер!';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Количество мест в салоне",
                                icon: Icon(Icons.person)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Введите коректное количество мест!';
                              }
                              return null;
                            },
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                print("Sending");
                              }
                            },
                            child: Text('Submit'),
                          )
                        ]))))));
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                    child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                print("Sending");
                              }
                            },
                            child: Text('Submit'),
                          )
                        ]))))));
  }
}

class RouteList extends StatefulWidget {
  @override
  RouteListState createState() {
    return RouteListState();
  }
}

class RouteListState extends State<RouteList> {
  List<Text> texts = List();
  @override
  void initState() {
    for (int i = 0; i < 69; i++) 
    texts.add(Text(
      i.toString(),
      style: TextStyle(
        color:Colors.black
      )
      ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                    child:
                        ListWheelScrollView(itemExtent: 50, children: texts)))));
  }
}
