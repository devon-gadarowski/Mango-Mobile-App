import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Mango',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
          fillColor: Color(0x5C75A544),
          counterStyle: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          hintStyle: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          errorStyle: GoogleFonts.zillaSlab(color: Colors.red)
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF75A544),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        primarySwatch: Colors.orange,
      ),
      home: MangoHomePage(),
    );
  }
}

class MangoTitle extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("mango", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 32)),
        Flexible(child: SizedBox(width: 5)),
        SizedBox(height: 32, child: Image(image: AssetImage('assets/mango.png'), fit: BoxFit.scaleDown))
      ]
    );
  }
}

class MangoHomePage extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: FractionallySizedBox(
        heightFactor: 1,
        widthFactor: 1,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xC2F6CD5A), Color(0xFFFF8C42), Color(0xFFEB4F4C)],
              stops: [0.204, 0.4936, 0.9441]
            )
          ),
          child: MangoLoginBox()
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
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Logging In')));
      //var response = await http.post("https://mangogreenhouse.com/api/login", body: {'email': this.email, 'password': this.password});
    }
  }

  // https://flutter.dev/docs/cookbook/forms/validation
  // https://medium.com/flutter-community/realistic-forms-in-flutter-part-1-327929dfd6fd
  Widget build(BuildContext context)
  {
    return FractionallySizedBox(
      heightFactor: 0.6,
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Form(
          key: _loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              FractionallySizedBox(
                child: MangoTitle()
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.4)),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextFormField(
                  decoration: InputDecoration(filled: true, hintText: "email"),
                  validator: (value) {
                    if (value.isEmpty)
                    {
                      return 'password invalid';
                    }

                    return null;
                  },
                  onSaved: (val) => setState(() => this.email = val)
                )
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextFormField(
                  decoration: InputDecoration(filled: true, hintText: "password"),
                  validator: (value) {
                    if (value.isEmpty)
                    {
                      return 'password invalid';
                    }

                    return null;
                  },
                  onSaved: (val) => setState(() => this.password = val),
                )
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.4)),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: RaisedButton(
                  onPressed: () { doLogin(); },
                  child: Text("Log In", style: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold))
                )
              )
            ]
          )
        )
      )
    );
  }
}