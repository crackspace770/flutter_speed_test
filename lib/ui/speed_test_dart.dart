
import 'package:flutter/material.dart';
import 'package:speed_test_dart/classes/coordinate.dart';
import 'package:speed_test_dart/classes/server.dart';
import 'package:speed_test_dart/speed_test_dart.dart';

//speed_test_dart
class SpeedTestDartPage extends StatefulWidget {
  const SpeedTestDartPage({super.key});

  @override
  State<SpeedTestDartPage> createState() => _SpeedTestDartPageState();
}

class _SpeedTestDartPageState extends State<SpeedTestDartPage> {

  SpeedTestDart tester = SpeedTestDart();
  List<Server> bestServersList = [];

  double downloadRate = 0;
  double uploadRate = 0;

  bool readyToTest = false;
  bool loadingDownload = false;
  bool loadingUpload = false;

  Future<void> setBestServers() async {
    // Manually create a server object with your custom domain
    final customServer = Server(
      1, // id
      'Custom Server', // name
      'ID', // country
      'Your Sponsor', // sponsor
      'linode.des.net.id', // host
      'http://linode.des.net.id/', // url
      0.0, // latitude
      0.0, // longitude
      0.0, // distance (set initially to 0.0)
      0.0, // latency (set initially to 0.0)
      Coordinate(0.0, 0.0), // geoCoordinate (use dummy coordinates)
    );

    // Set the custom server as the best server
    setState(() {
      bestServersList = [customServer];
      readyToTest = true;
    });
  }

  Future<void> _testDownloadSpeed() async {
    setState(() {
      loadingDownload = true;
    });

    // Use the custom server for download speed testing
    final _downloadRate =
    await tester.testDownloadSpeed(servers: bestServersList);

    setState(() {
      downloadRate = _downloadRate;
      loadingDownload = false;
    });
  }

  Future<void> _testUploadSpeed() async {
    setState(() {
      loadingUpload = true;
    });

    // Use the custom server for upload speed testing
    final _uploadRate = await tester.testUploadSpeed(servers: bestServersList);

    setState(() {
      uploadRate = _uploadRate;
      loadingUpload = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setBestServers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speed Test Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Download Test:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (loadingDownload)
                Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Testing download speed...'),
                  ],
                )
              else
                Text('Download rate  ${downloadRate.toStringAsFixed(2)} Mb/s'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: loadingDownload
                    ? null
                    : () async {
                  if (!readyToTest || bestServersList.isEmpty) return;
                  await _testDownloadSpeed();
                },
                child: const Text('Start'),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Upload Test:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (loadingUpload)
                Column(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Testing upload speed...'),
                  ],
                )
              else
                Text('Upload rate ${uploadRate.toStringAsFixed(2)} Mb/s'),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: loadingUpload
                    ? null
                    : () async {
                  if (!readyToTest || bestServersList.isEmpty) return;
                  await _testUploadSpeed();
                },
                child: const Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
