import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'globals.dart';

class MangoRegisterPage extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xC2F6CD5A), Color(0xFFFF8C42), Color(0xFFEB4F4C)],
            stops: [0.204, 0.4936, 0.9441]
          )
        ),
        width: window.physicalSize.width,
        height: window.physicalSize.height,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: MangoRegisterBox()
          )
        )
      )
    );
  }
}

class MangoRegisterBox extends StatefulWidget
{
  MangoRegisterState createState()
  {
    return MangoRegisterState();
  }
}

class MangoRegisterState extends State<MangoRegisterBox>
{
  final _registerKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password1 = '';
  String password2 = '';

  // https://flutter.dev/docs/cookbook/networking/fetch-data
  void doRegister() async
  {
    if (_registerKey.currentState.validate())
    {
      FocusScope.of(context).unfocus();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Registering Account')));
      var response = json.decode((await http.post(url + "/api/register", headers: {"Content-Type": "application/json"}, body: json.encode({'name': this.name, 'email': this.email, 'password': this.password1}))).body);

      print(response);

      Scaffold.of(context).hideCurrentSnackBar();

      if (!response["success"])
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bad Register :(')));
      else
        Navigator.pushReplacementNamed(context, '/login');
    }
  }

// https://medium.com/swlh/working-with-forms-in-flutter-a176cca9449a

  // https://flutter.dev/docs/cookbook/forms/validation
  // https://medium.com/flutter-community/realistic-forms-in-flutter-part-1-327929dfd6fd
  Widget build(BuildContext context)
  {
    return Container(
      width: 0.4 * window.physicalSize.width,
      height: 0.42 * window.physicalSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        key: _registerKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Flexible(child: FractionallySizedBox(heightFactor: 0.0)),
            FractionallySizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("mango", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 32)),
                  Flexible(child: SizedBox(width: 5)),
                  SizedBox(height: 32, child: Image(image: AssetImage('assets/mango.png'), fit: BoxFit.scaleDown))
                ]
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.4)),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextFormField(
                decoration: InputDecoration(filled: true, hintText: "name"),
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'name missing';
                  }

                  return null;
                },
                onChanged: (val) => setState(() => this.name = val)
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextFormField(
                decoration: InputDecoration(filled: true, hintText: "email"),
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'email missing';
                  }

                  if (!value.contains('@') || !value.contains('.'))
                  {
                    return 'email is not valid';
                  }

                  return null;
                },
                onChanged: (val) => setState(() => this.email = val)
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(filled: true, hintText: "password"),
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'password missing';
                  }

                  return null;
                },
                onChanged: (val) => setState(() => this.password1 = val),
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(filled: true, hintText: "confirm password"),
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'confirm password missing';
                  }

                  if (value != this.password1)
                  {
                    return 'passwords do not match';
                  }

                  return null;
                },
                onChanged: (val) => setState(() => this.password2 = val),
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.6)),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: RaisedButton(
                onPressed: () { doRegister(); },
                child: Text("Register", style: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold))
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
            FractionallySizedBox(
              widthFactor: 1,
              child: FlatButton(
                child: Text("already have an account? log in", style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                onPressed: () { Navigator.pushReplacementNamed(context, "/login"); },
              )
            )
          ]
        )
      )
    );
  }
}