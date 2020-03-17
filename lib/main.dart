import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


import 'package:flutter/material.dart';

void main() => runApp(MyApp());

//https://flutter.dev/docs/cookbook/navigation/named-routes
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Mango',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Color(0x5C75A544),
          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
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
      routes: {
          '/': (context) => MangoLoginPage(),
          '/register': (context) => MangoRegisterPage()
      },
      initialRoute: '/'
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

class MangoLoginPage extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      var response = await http.post("http://localhost:5000/api/login", body: {'email': this.email, 'password': this.password});

      print(response);
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
                  obscureText: true,
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
              ),
              Flexible(child: FractionallySizedBox()),
              FractionallySizedBox(
                child: FlatButton(
                  child: Text("new to mango? sign up", style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold)),
                  onPressed: () { Navigator.pushNamed(context, '/register'); },
                )
              )
            ]
          )
        )
      )
    );
  }
}

class MangoRegisterPage extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          child: MangoRegisterBox()
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
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Registering Account')));
      var response = await http.post("http://localhost:5000/api/register", body: {'name': this.name, 'email': this.email, 'password': this.password1});

      print(response);
    }
  }

// TODO: Improve and cleanup Forms
// https://medium.com/swlh/working-with-forms-in-flutter-a176cca9449a

  // https://flutter.dev/docs/cookbook/forms/validation
  // https://medium.com/flutter-community/realistic-forms-in-flutter-part-1-327929dfd6fd
  Widget build(BuildContext context)
  {
    return FractionallySizedBox(
      heightFactor: 0.8,
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Form(
          key: _registerKey,
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
              Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
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
              Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
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
              Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
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
              Flexible(child: FractionallySizedBox(heightFactor: 0.4)),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: RaisedButton(
                  onPressed: () { doRegister(); },
                  child: Text("Register", style: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold))
                )
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
              FractionallySizedBox(
                widthFactor: 1,
                child: FlatButton(
                  child: Text("already have an account? log in", style: GoogleFonts.zillaSlab(fontWeight: FontWeight.bold)),
                  onPressed: () { Navigator.pop(context); },
                )
              )
            ]
          )
        )
      )
    );
  }
}