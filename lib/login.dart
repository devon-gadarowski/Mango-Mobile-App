import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'globals.dart';

class MangoLoginPage extends StatelessWidget
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
            child: MangoLoginBox()
          )
        )
      )
    );
  }
}


class MangoLoginBox extends StatefulWidget
{
  MangoLoginState createState()
  {
    return MangoLoginState();
  }
}

class MangoLoginState extends State<MangoLoginBox>
{
  final _loginKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  // https://flutter.dev/docs/cookbook/networking/fetch-data
  void doLogin() async
  {
    if (_loginKey.currentState.validate())
    {
      FocusScope.of(context).unfocus();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Logging In...')));
      var res = await http.post(url + "/api/login", headers: {"Content-Type": "application/json"}, body: json.encode({'email': this.email, 'password': this.password}));
      var response = json.decode(res.body);

      print(response);

      Scaffold.of(context).hideCurrentSnackBar();

      if (res.statusCode == 201)
      {
        Navigator.pushNamed(context, '/verify');  
      }
      else if (!response["success"])
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Bad Login :(')));
      }
      else
      {
        int index = res.headers['set-cookie'].indexOf(';');
        cookie = (index == -1) ? res.headers['set-cookie'] : res.headers['set-cookie'].substring(0, index);
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  // https://flutter.dev/docs/cookbook/forms/validation
  // https://medium.com/flutter-community/realistic-forms-in-flutter-part-1-327929dfd6fd
  Widget build(BuildContext context)
  {
    return Container(
      width: 0.4 * window.physicalSize.width,
      height: 0.3 * window.physicalSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Form(
        key: _loginKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
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
            Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextFormField(
                decoration: InputDecoration(filled: true, hintText: "email"),
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'email invalid';
                  }

                  return null;
                },
                onChanged: (val) => setState(() => this.email = val)
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.4)),
            FractionallySizedBox(
              widthFactor: 0.85,
              child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(filled: true, hintText: "password"),
                validator: (value) {
                  if (value.isEmpty)
                  {
                    return 'password invalid';
                  }

                  return null;
                },
                onChanged: (val) => setState(() => this.password = val),
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: RaisedButton(
                onPressed: () { doLogin(); },
                child: Text("Log In", style: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold))
              )
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
            FractionallySizedBox(
              child: FlatButton(
                child: Text("new to mango? sign up", style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                onPressed: () { Navigator.pushReplacementNamed(context, '/register'); },
              )
            )
          ]
        )
      )
    );
  }
}