import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'globals.dart';

class MangoVerifyEmailPage extends StatelessWidget
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
            child: MangoVerifyBox()
          )
        )
      )
    );
  }
}

class MangoVerifyBox extends StatefulWidget
{
  MangoVerifyState createState()
  {
    return MangoVerifyState();
  }
}

class MangoVerifyState extends State<MangoVerifyBox>
{
  final _verifyKey = GlobalKey<FormState>();
  String authCode = '';

  // https://flutter.dev/docs/cookbook/networking/fetch-data
  void doVerify() async
  {
    if (_verifyKey.currentState.validate())
    {
      FocusScope.of(context).unfocus();
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Verifying Email...')));
      var res = await http.post(url + "/api/verify", headers: {"Content-Type": "application/json"}, body: json.encode({'authCode': this.authCode}));
      var response = json.decode(res.body);

      print(response);

      Scaffold.of(context).hideCurrentSnackBar();

      if (!response["success"])
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to verify')));
      }
      else
      {
        int index = res.headers['set-cookie'].indexOf(';');
        cookie = (index == -1) ? res.headers['set-cookie'] : res.headers['set-cookie'].substring(0, index);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> r) => false);
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
        key: _verifyKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(child: Text("oh no!", style: GoogleFonts.nunito(fontWeight: FontWeight.w900, fontSize: 32))),
                    Flexible(child: SizedBox(width: 10)),
                    Flexible(child: SvgPicture.asset("assets/Sad-Banana.svg", width: 50))
                  ]
                )
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
              Flexible(
                child: Padding(
                  child: Text(
                    "You have not verified your email. Please check your inbox for your secret code.",
                    style: GoogleFonts.zillaSlab(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12)
                ),
                flex: 0
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.5)),
              FractionallySizedBox(
                widthFactor: 0.85,
                child: TextFormField(
                  inputFormatters: <TextInputFormatter>[new LengthLimitingTextInputFormatter(6)],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(filled: true, hintText: "secret code"),
                  validator: (value) {
                    if (value.isEmpty)
                    {
                      return 'please enter the secret code';
                    }

                    return null;
                  },
                  onChanged: (val) => setState(() => this.authCode = val)
                )
              ),
              Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: RaisedButton(
                  onPressed: () { doVerify(); },
                  child: Text("Verify", style: GoogleFonts.zillaSlab(color: Colors.white, fontWeight: FontWeight.bold)
                )
              )
            ),
          ]
        )
      )
    );
  }
}