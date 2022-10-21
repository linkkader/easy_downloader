// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/utils/save_part.dart';
import '../model/download.dart';
import '../model/download_info.dart';
import '../model/part_file.dart';
import '../storage/status.dart';

ReceivePort downloadIsolate() {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn((message) {
    Task? downloadInfo;
    HttpClient client = HttpClient();
    var sendPort = message;
    var receivePort = ReceivePort();
    var completer = Completer();
    message.send(receivePort.sendPort);
    late StreamSubscription subscription;
    subscription = receivePort.listen((message) {
      print(message);
      if (message is Completer){
        completer.complete();
      }
      if (message is Task && downloadInfo == null) {
        downloadInfo ??= message;
        client.getUrl(Uri.parse(downloadInfo!.url))
            .then((value) {
              downloadInfo!.headers.forEach((k, v) {
                value.headers.add(k, v);
              });
              return value.close();
            })
            .then((value) async {
              var download = Download(
                path: downloadInfo!.path,
                totalLength: value.contentLength,
                maxSplit: downloadInfo!.maxSplit,
                sendPortMainThread: sendPort,
                filename: downloadInfo!.filename,
                headers: downloadInfo!.headers,
                tempPath: downloadInfo!.tempPath,
                downloadId: downloadInfo!.downloadId,
              );
              sendPort.send([SendPortStatus.setDownload, download, receivePort.sendPort, completer]);
              await completer.future;
              print("lest go");
              var partFile = PartFile(start: 0, end: download.totalLength, id: download.parts.length, download: download, isolate: Isolate.current);
              savePart(value, partFile, download, downloadInfo!);
              subscription.cancel();
        });
        // subscription.cancel();
      }
    });
  }, receivePort.sendPort).then((value) => {
    receivePort.sendPort.send([SendPortStatus.childIsolate, value])
  });
  return receivePort;
}