import 'package:flutter/material.dart';

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
            body:SafeArea(child: 
             Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
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
                            return "В этом поле должны быть только буквы!";
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
