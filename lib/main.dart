import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:mango_mobile_app/home.dart';

import 'login.dart';
import 'register.dart';
import 'home.dart';
import 'add_device.dart';
import 'verify_email.dart';

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
          '/login': (context) => MangoLoginPage(),
          '/register': (context) => MangoRegisterPage(),
          '/home': (context) => MangoHomePage(),
          '/addDevice': (context) => MangoAddDevicePage(),
          '/verify': (context) => MangoVerifyEmailPage()
      },
      initialRoute: '/login'
    );
  }
}