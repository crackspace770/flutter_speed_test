
//flutter_speedtest
import 'package:flutter/material.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';

class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  // https://speedtest.globalxtreme.net:8080/upload?nocache=a58d34b4-f86b-4088-9396-eeac6fd27baf&guid=f3e39d01-247d-4a40-afaf-ef5c276b0f75

  final _speedtest = FlutterSpeedtest(
    baseUrl: 'http://linode.des.net.id/',
    //baseUrl: 'https://speedtest.globalxtreme.net:8080',
    pathDownload: '/download',
    pathUpload: '/upload',
    pathResponseTime: '/ping',
  );

  double _progressDownload = 0;
  double _progressUpload = 0;

  int _ping = 0;
  int _jitter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Speedtest',
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Download: $_progressDownload'),
              Text('upload: $_progressUpload'),
              Text('Ping: $_ping'),
              Text('Jitter: $_jitter'),
              ElevatedButton(
                onPressed: () {
                  _speedtest.getDataspeedtest(
                    downloadOnProgress: ((percent, transferRate) {
                      setState(() {
                        _progressDownload = transferRate;
                      });
                    }),
                    uploadOnProgress: ((percent, transferRate) {
                      setState(() {
                        _progressUpload = transferRate;
                      });
                    }),
                    progressResponse: ((responseTime, jitter) {
                      setState(() {
                        _ping = responseTime;
                        _jitter = jitter;
                      });
                    }),
                    onError: ((errorMessage) {
                      // print(errorMessage);
                    }),
                    onDone: () => debugPrint('done'),
                  );
                },
                child: const Text('test download'),
              ),
            ],
          )),
    );
  }
}