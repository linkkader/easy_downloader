import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_downloader/dart_downloader2.dart';
import 'package:easy_downloader/extensions/enum.dart';
import 'package:easy_downloader/extensions/int_extension.dart';
import 'package:easy_downloader/monitor/download_monitor.dart';
import 'package:easy_downloader/monitor/monitor.dart';
import 'package:flutter_test/flutter_test.dart';

import 'model/status.dart';
import 'model/status.dart';



void main() {
  test('adds one to input values', () async {
    var completer = Completer();

    HttpClient http = HttpClient();
    var dio = Dio();
    var res = await dio.get("https://manga-tube.me/series/fire_emblem_awakening_4_koma_kings", options: Options(headers: {
      //'User-Agent': 'Mozilla/5.0 (Linux; Android 12; SM-A528B Build/SP1A.210852.016; wv) AppleWebKit/537'
    }));
    print(res.data);
    return;
    var r = await http.getUrl(Uri.parse("https://mangas-origines.fr/"));
    var response = await r.close();
    response.listen((event) {
      print(utf8.decode(event));
    }, onDone: () {
      completer.complete();
    });
    await completer.future;
    return;


    var file = File('test/test.mp4');
    //500KB
    var url = "https://www.learningcontainer.com/download/sample-mp4-video-file-download-for-testing/?wpdmdl=2727&refresh=62dca61b7ad061658627611";
    //100MB
    url = "https://speed.hetzner.de/100MB.bin";
    //100MB
    //url = "https://raw.githubusercontent.com/yourkin/fileupload-fastapi/a85a697cab2f887780b3278059a0dd52847d80f3/tests/data/test-10mb.bin";
    Stopwatch stopwatch = Stopwatch()..start();
    DartDownloader().download(url,
        monitor: DownloadMonitor(
          duration: const Duration(seconds: 2),
          blockMonitor: (blocks) {

          },
          onProgress: (downloaded, total, speed, status) {
            print("downloaded $status ${DownloadStatus.completed}: ${downloaded.toHumanReadableSize()} total: ${total.toHumanReadableSize()} speed: ${speed.toHumanReadableSize()}/s");
            if (status <= DownloadStatus.completed) {
              print("download completed in ${stopwatch.elapsedMilliseconds} ms");
              completer.complete();
            }},
        ));
    await completer.future;
    print("download completed in ${stopwatch.elapsedMilliseconds} ms");
  });
}
