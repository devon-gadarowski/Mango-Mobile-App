import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'globals.dart';

class MangoAddDevicePage extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return Scaffold(
        body: Container(
        height: window.physicalSize.height,
        width: window.physicalSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xC2F6CD5A), Color(0xFFFF8C42), Color(0xFFEB4F4C)],
            stops: [0.204, 0.4936, 0.9441]
          )
        ),
        child: Center(child: MangoAddDevice())
      )
    );
  }
}

class MangoAddDevice extends StatefulWidget
{
  MangoAddDeviceState createState()
  {
    return MangoAddDeviceState();
  }
}

class MangoAddDeviceState extends State<MangoAddDevice>
{
  int phase = 0;

  void addDevice() async
  {
      var response = json.decode((await http.post(url + "/api/addDevice", headers: {"Content-Type": "application/json", "Cookie": cookie}, body: json.encode({}))).body);

      print(response);

      if (!response['success'])
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to add new sensor :(')));
        return;
      }
  }

  Widget build(BuildContext context)
  {
      return Container(
      width: 0.4 * window.physicalSize.width,
      height: 0.3 * window.physicalSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Center(child: Text("TODO", style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20), textAlign: TextAlign.center))
    );
  }
}