// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:isolate';
import '../easy_downloader.dart';
import '../storage/status.dart';

///get length of file create by [EasyDownloader]
Future<int> currentLength(Download download) async {
  var receivePort = ReceivePort();
  var completer = Completer<int>();
  download.sendPortMainThread
      .send([SendPortStatus.currentLength, receivePort.sendPort]);
  receivePort.listen((message) {
    if (message is List && message[0] == SendPortStatus.currentLength) {
      completer.complete(message[1]);
    }
  });
  return completer.future;
}
