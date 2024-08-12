import 'package:dio_test_speed/ui/flutter_speedtest.dart';
import 'package:dio_test_speed/ui/internet_speed_test.dart';
import 'package:dio_test_speed/ui/speed_test_dart.dart';
import 'package:dio_test_speed/ui/speed_test_page.dart';
import 'package:dio_test_speed/service/speed_test_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Speed Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FlutterSpeedTestPage(),
    );
  }
}

