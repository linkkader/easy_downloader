// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/utils/save_part.dart';
import '../model/download.dart';
import '../model/download_info.dart';
import '../storage/status.dart';
///stop
ReceivePort resumeIsolate() {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn((message) {
    DownloadInfo? downloadInfo;
    HttpClient? client;
    Download? download;
    var sendPort = message;
    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    //sendPort.send([SendPortStatus.updateMainSendPort, sendPort, receivePort.sendPort]);
    late StreamSubscription subscription;
    subscription = receivePort.listen((message) async {
      if (message is DownloadInfo) {
        downloadInfo ??= message;
      }
      if (message is HttpClient) {
        client ??= message;
      }
      if (message is Download) {
        download ??= message;
      }
      if (downloadInfo != null && client != null && download != null) {
        //make an assert pause is possible only when minimum one part is downloading
        var util = download!.parts.first.toUtilDownload();
        var partFile = download!.parts.first;
        if (!partFile.mustRetry()){
          print("canceling subscription");
          subscription.cancel();
          return;
        }
        var request = await client!.getUrl(Uri.parse(downloadInfo!.url));
        request.headers.add("Range", 'bytes=${util.start}-${util.end}');
        request.close().then((value) {
          savePart(value, partFile, download!, downloadInfo!);
        });
        subscription.cancel();
      }
    });
  }, receivePort.sendPort).then((value) {
    receivePort.sendPort.send([SendPortStatus.childIsolate, value]);
  });
  return receivePort;
}