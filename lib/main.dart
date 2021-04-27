import 'package:flutter/material.dart';
import 'package:flutter_dust/AirResult.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  AirResult _result;

  Future<AirResult> fetchData() async {
    var uri = Uri.parse(
        'https://api.airvisual.com/v2/nearest_city?key=59a06f27-fe65-483b-84f6-1192ccf78c59');
    var response = await http.get(uri);

    AirResult result = AirResult.fromJson(json.decode(response.body));
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((airResult) {
      setState(() {
        _result = airResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: _result?.data?.current == null
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('현재 위치 미세먼지', style: TextStyle(fontSize: 30)),
                    SizedBox(
                      height: 16,
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text('얼굴사진'),
                                Text(
                                  '${_result.data.current.pollution.aqius}°',
                                  style: TextStyle(fontSize: 40),
                                ),
                                Text(
                                  getString(_result),
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            color: getColor(_result),
                            padding: const EdgeInsets.all(8.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Image.network(
                                      'https://airvisula.com/images/${_result.data.current.weather.ic}.png',
                                      width: 32,
                                      height: 32,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      '${_result.data.current.weather.tp}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Text('습도 ${_result.data.current.weather.hu}%'),
                                Text(
                                    '풍속 ${_result.data.current.weather.ws}m/s'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)))
                          .copyWith(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange),
                      ),
                      child:
                          Icon(Icons.refresh, color: Colors.white, size: 30.0),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
    ));
  }

  Color getColor(AirResult result) {
    if (result.data.current.pollution.aqius < 50) {
      return Colors.greenAccent;
    } else if (result.data.current.pollution.aqius < 100) {
      return Colors.yellow;
    } else if (result.data.current.pollution.aqius < 150) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  String getString(AirResult result) {
    if (result.data.current.pollution.aqius < 50) {
      return '좋음';
    } else if (result.data.current.pollution.aqius < 100) {
      return '보통';
    } else if (result.data.current.pollution.aqius < 150) {
      return '나쁨';
    } else {
      return '최악';
    }
  }
}
