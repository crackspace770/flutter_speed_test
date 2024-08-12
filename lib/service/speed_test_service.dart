import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class SpeedTestService {
  static const _fileSize = 10 * 1024 * 1024; // 10MB
  static const _testUrl = 'http://proof.ovh.net/files/10Mb.dat'; // Replace with your own URL

  Future<double> testDownloadSpeed() async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.get(Uri.parse(_testUrl));
      final elapsedTime = stopwatch.elapsedMilliseconds / 1000;
      final fileSizeInMB = response.contentLength! / (1024 * 1024);
      final speedMbps = (fileSizeInMB / elapsedTime) * 8;
      return speedMbps;
    } catch (e) {
      throw Exception('Download speed test failed: $e');
    }
  }

  Future<double> testUploadSpeed() async {
    final random = Random();
    final bytes = Uint8List.fromList(List.generate(_fileSize, (_) => random.nextInt(256)));
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.post(
        Uri.parse(_testUrl),
        body: bytes,
      );
      final elapsedTime = stopwatch.elapsedMilliseconds / 1000;
      final fileSizeInMB = bytes.length / (1024 * 1024);
      final speedMbps = (fileSizeInMB / elapsedTime) * 8;
      return speedMbps;
    } catch (e) {
      throw Exception('Upload speed test failed: $e');
    }
  }

  Future<int> testPing() async {
    final stopwatch = Stopwatch()..start();
    try {
      await http.get(Uri.parse(_testUrl));
      final ping = stopwatch.elapsedMilliseconds;
      return ping;
    } catch (e) {
      throw Exception('Ping test failed: $e');
    }
  }
}