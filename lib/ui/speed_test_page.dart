
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

//flutter_internet_speed_test
class FlutterSpeedTestPage extends StatefulWidget {
  const FlutterSpeedTestPage({Key? key}) : super(key: key);

  @override
  State<FlutterSpeedTestPage> createState() => _FlutterSpeedTestPageState();
}

class _FlutterSpeedTestPageState extends State<FlutterSpeedTestPage> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;

  String? _ip;
  String? _asn;
  String? _isp;

  String _unitText = 'Mbps';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Internet Speed Test Example'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Download Speed',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Progress: $_downloadProgress%'),
                  Text('Download Rate: $_downloadRate $_unitText'),
                  if (_downloadCompletionTime > 0)
                    Text(
                        'Time taken: ${(_downloadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Upload Speed',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Progress: $_uploadProgress%'),
                  Text('Upload Rate: $_uploadRate $_unitText'),
                  if (_uploadCompletionTime > 0)
                    Text(
                        'Time taken: ${(_uploadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('IP: ${_ip ?? '--'} | ASP: ${_asn ?? '--'} | ISP: ${_isp ?? '--'}'),
              ),
              if (!_testInProgress) ...{
                ElevatedButton(
                  child: const Text('Start Testing'),
                  onPressed: () async {
                    reset();
                    try {
                      await internetSpeedTest.startTesting(
                        useFastApi: false,
                        downloadTestServer: 'http://linode.des.net.id/',
                        uploadTestServer: 'http://linode.des.net.id/',
                        //fileSize: 50,  // Increase file size for more accurate results
                        onStarted: () {
                          setState(() => _testInProgress = true);
                        },
                        onCompleted: (TestResult download, TestResult upload) {
                          setState(() {
                            _downloadRate = download.transferRate;
                            _unitText = download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                            _downloadProgress = '100';
                            _downloadCompletionTime = download.durationInMillis;

                            _uploadRate = upload.transferRate;
                            _uploadProgress = '100';
                            _uploadCompletionTime = upload.durationInMillis;
                            _testInProgress = false;
                          });
                        },
                        onProgress: (double percent, TestResult data) {
                          setState(() {
                            _unitText = data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                            if (data.type == TestType.download) {
                              _downloadRate = data.transferRate;
                              _downloadProgress = percent.toStringAsFixed(2);
                            } else {
                              _uploadRate = data.transferRate;
                              _uploadProgress = percent.toStringAsFixed(2);
                            }
                          });
                        },
                        onError: (String errorMessage, String speedTestError) {
                          print('Error: $errorMessage, SpeedTestError: $speedTestError');
                          reset();
                        },
                        onCancel: () {
                          reset();
                        },
                      );
                    } catch (e) {
                      print('Test failed: $e');
                      reset();
                    }
                  },
                )
              } else ...{
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => internetSpeedTest.cancelTest(),
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancel'),
                  ),
                )
              },
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      _testInProgress = false;
      _downloadRate = 0;
      _uploadRate = 0;
      _downloadProgress = '0';
      _uploadProgress = '0';
      _unitText = 'Mbps';
      _downloadCompletionTime = 0;
      _uploadCompletionTime = 0;

      _ip = null;
      _asn = null;
      _isp = null;
    });
  }
}