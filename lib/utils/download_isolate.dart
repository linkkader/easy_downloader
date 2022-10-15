// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/utils/save_part.dart';
import '../model/download.dart';
import '../model/download_info.dart';
import '../model/part_file.dart';
import '../model/status.dart';

ReceivePort downloadIsolate() {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn((message) {
    DownloadInfo? downloadInfo;
    HttpClient client = HttpClient();
    var sendPort = message;
    var receivePort = ReceivePort();
    message.send(receivePort.sendPort);
    late StreamSubscription subscription;
    subscription = receivePort.listen((message) {
      if (message is DownloadInfo) {
        downloadInfo ??= message;
      }
      if (downloadInfo != null) {
        client.getUrl(Uri.parse(downloadInfo!.url))
            .then((value) => value.close())
            .then((value) async {
          var download = Download(path: downloadInfo!.path, totalLength: value.contentLength, maxSplit: 8, sendPortMainThread: sendPort);
          sendPort.send([SendPortStatus.setDownload, download]);
          var partFile = PartFile(start: 0, end: download.totalLength, id: download.parts.length, download: download, isolate: Isolate.current);
          savePart(value, partFile, download, downloadInfo!);
        });
        subscription.cancel();
      }
    });
  }, receivePort.sendPort);
  return receivePort;
}