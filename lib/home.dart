import 'dart:collection';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'globals.dart';

class MangoHomePage extends StatelessWidget
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
        child: MangoDeviceList()
      )
    );
  }
}

class MangoDeviceList extends StatefulWidget
{
  MangoDeviceListState createState()
  {
    return MangoDeviceListState();
  }
}

class MangoDeviceListState extends State<MangoDeviceList>
{
  List devices = [];

  void getUserDevices() async
  {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Fetching Devices...')));
    var response = json.decode((await http.post(url + "/api/getDevices", headers: {"Content-Type": "application/json", "Cookie": cookie}, body: json.encode({}))).body);

    Scaffold.of(context).hideCurrentSnackBar();

    if (!response["success"])
    {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch device info :(')));
        return;
    }

    this.setState(() {
      this.devices = response["devices"];
    });
  }

  void initState()
  {
    super.initState();

    Future.delayed(Duration.zero, () => this.getUserDevices());
  }

  Widget build(BuildContext context)
  {
    return RefreshIndicator(
      child: ListView.builder(
        addAutomaticKeepAlives: false,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: this.devices.length + 1,
        itemBuilder: (BuildContext context, int i) {
          if (i != this.devices.length)
            return Center(
                child: MangoDeviceCard(
                id: this.devices[i]["_id"],
                alias: this.devices[i]["alias"],
                postFrequency: this.devices[i]["postFrequency"],
              )
            );
          else
            return Align(alignment: Alignment.center, child: AddDeviceCard());
        }
      ),
      onRefresh: () async => Navigator.pushReplacementNamed(context, "/home")
    );
  }
}

class AddDeviceCard extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return FlatButton(
      onPressed: () {},
      child: Container(
        height: 0.15 * window.physicalSize.height,
        width: 0.2 * window.physicalSize.height,
        margin: EdgeInsets.fromLTRB(0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Align(
              alignment: Alignment.center,
              child: Text("Sign in to our website to add a new Greenhouse", style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20), textAlign: TextAlign.center)
            ),
            Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
            SvgPicture.asset("assets/greenhouse.svg")
          ]
        )
      )
    );
  }
}

class MangoDeviceCard extends StatefulWidget
{
  final String id;
  final String alias;
  final int postFrequency;

  MangoDeviceCard({this.id, this.alias, this.postFrequency});

  MangoDeviceCardState createState()
  {
    return MangoDeviceCardState();
  }
}

class MangoDeviceCardState extends State<MangoDeviceCard>
{
  String error = "Fetching the info...";

  SplayTreeMap<DateTime, Condition> conditions = new SplayTreeMap();

  void initState()
  {
    super.initState();

    Future.delayed(Duration.zero, () => this.getLatestConditions());
  }

  void getLatestConditions() async
  {
    var response = json.decode((await http.post(url + "/api/getConditions", headers: {"Content-Type": "application/json", "Cookie": cookie}, body: json.encode({"deviceID": widget.id, "mostRecent": "false"}))).body);

    if (!response["success"])
    {
      this.setState(() => this.error = "Failed to fetch conditions :(");
      return;
    }

    for (var record in response["conditions"])
    {
      List<String> l = record["datetime"].toString().split(new RegExp(r" |:|/"));
      DateTime dt = new DateTime.utc(int.parse(l[2]), int.parse(l[0]), int.parse(l[1]), int.parse(l[3]) + ((l[5] == "PM") ? 12 : 0), int.parse(l[4]));

      print(record);

      if (DateTime.now().millisecondsSinceEpoch - dt.millisecondsSinceEpoch > 24 * 60 * 60 * 1000)
        continue;

      conditions.putIfAbsent(dt.toLocal(), () => new Condition(datetime: dt, temp: ((record["curTemp"] * 9.0 / 5.0) + 32), humidity: record["curHumidity"] * 1.0));
    }

    if (conditions.length <= 0)
      this.setState(() => this.error = "No recent conditions :(");
    else
      this.setState(() => this.error = "");
  }

  Widget build(BuildContext context)
  {
    if (this.error != "")
    {
      return Container(
        height: 0.4 * window.physicalSize.height,
        margin: EdgeInsets.fromLTRB(0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width, 0.00 * window.physicalSize.width),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
            Flexible(child: SensorName(name: widget.alias), flex: 0),
            Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
            Flexible(child: Text(this.error, style: GoogleFonts.zillaSlab(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center), flex: 0),
          ]
        )
      );
    }
    else
    {
      return Container(
        height: 0.4 * window.physicalSize.height,
        margin: EdgeInsets.fromLTRB(0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width, 0.05 * window.physicalSize.width, 0.00 * window.physicalSize.width),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Flexible(child: FractionallySizedBox(heightFactor: 1.1)),
            Flexible(child: SensorName(name: widget.alias), flex: 0),
            Flexible(child: FractionallySizedBox(heightFactor: 0.3)),
            Flexible(child: DateTimeDisplay(dateTime: this.conditions.entries.last.key), flex: 0),
            Flexible(child: FractionallySizedBox(heightFactor: 0.8)),
            Flexible(child: TempDisplay(temp: "Temperature: " + conditions.entries.last.value.temp.toString() + "°F", conditions: this.conditions), flex: 0),
            Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
            Flexible(child: HumidityDisplay(humidity: "Humidity: " + conditions.entries.last.value.humidity.toString() + "%", conditions: this.conditions), flex: 0),
          ]
        )
      );
    }
  }
}

class SensorName extends StatelessWidget
{
  final String name;

  SensorName({this.name});

  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(name,
            style: GoogleFonts.nunito(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 22),
            textAlign: TextAlign.center
          )
        )
      ]
    );
  }
}

class DateTimeDisplay extends StatelessWidget
{
  final DateTime dateTime;

  DateTimeDisplay({this.dateTime});

  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(dateTime.month.toString() + "/" + dateTime.day.toString() + "/" + dateTime.year.toString() + " " + (dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12).toString() + ":" + (dateTime.minute < 10 ? "0":"") + (dateTime.minute).toString() + " " + (dateTime.hour > 11 ? "PM":"AM"),
          style: GoogleFonts.zillaSlab(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center
        )
      ]
    );
  }
}

class TempDisplay extends StatelessWidget
{
  final String temp;
  final SplayTreeMap<DateTime, Condition> conditions;

  TempDisplay({this.temp, this.conditions});

  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(temp,
              style: GoogleFonts.zillaSlab(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center
            ),
            flex: 0
          ),
          Flexible(
            child: SizedBox(
              height: 150,
              width: 245,
              child: charts.TimeSeriesChart(
                [new charts.Series<Condition, DateTime>(
                  id: 'temp',
                  colorFn: (_, __) => charts.Color(a: 0xFF, r: 0xFF, g: 0x3C, b: 0x38), //FF3C38
                  domainFn: (Condition cond, _) => cond.datetime.toLocal(),
                  measureFn: (Condition cond, _) => cond.temp,
                  data: conditions.values.toList()
                )],
                animate: true,
                domainAxis: new charts.DateTimeAxisSpec(
                  showAxisLine: true,
                  tickProviderSpec: charts.AutoDateTimeTickProviderSpec(),
                ),
                primaryMeasureAxis: new charts.NumericAxisSpec(
                  tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 5, dataIsInWholeNumbers: false, zeroBound: false)
                ),
              )
            ),
            flex: 0
          )
        ]
    );
  }
}

class HumidityDisplay extends StatelessWidget
{
  final String humidity;
  final SplayTreeMap<DateTime, Condition> conditions;

  HumidityDisplay({this.humidity, this.conditions});

  Widget build(BuildContext context)
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(humidity,
            style: GoogleFonts.zillaSlab(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center
          ),
          flex: 0
        ),
        Flexible(
          child: SizedBox(
            height: 150,
            width: 245,
            child: charts.TimeSeriesChart(
              [new charts.Series<Condition, DateTime>(
                id: 'temp',
                colorFn: (_, __) => charts.Color(a: 0xFF, r: 0x66, g: 0x99, b: 0xCC),
                domainFn: (Condition cond, _) => cond.datetime,
                measureFn: (Condition cond, _) => cond.humidity,
                data: conditions.values.toList()
              )],
              animate: true,
              domainAxis: new charts.DateTimeAxisSpec(
                showAxisLine: true,
                tickProviderSpec: charts.AutoDateTimeTickProviderSpec(),
              ),
              primaryMeasureAxis: new charts.NumericAxisSpec(
                tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: 5, dataIsInWholeNumbers: false, zeroBound: false)
              )
            )
          ),
          flex: 0
        )
      ]
    );
  }
}

class Condition
{
  final DateTime datetime;
  final double temp;
  final double humidity;

  Condition({this.datetime, this.temp, this.humidity});
}