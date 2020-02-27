import 'package:flutter/material.dart';
import 'package:flutter_app/prefs_manager.dart';

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
    return
    SafeArea(child: 
     Container(
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
            ]))));
  }
}