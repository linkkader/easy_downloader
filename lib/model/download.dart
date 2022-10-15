// Created by linkkader on 7/10/2022

import 'dart:async';
import 'dart:isolate';
import 'package:easy_downloader/model/status.dart';
import 'part_file.dart';

class Download{
  late SendPort sendPortMainThread;
  final int totalLength;
  final String path;
  final int maxSplit;
  DownloadStatus _status = DownloadStatus.downloading;
  final Map<int, PartFile> _parts = {};

  Timer? currentLengthTimer;
  List<SendPort> currentLengthSendPorts = [];

  Download({required this.totalLength,required this.path, required this.maxSplit, required this.sendPortMainThread});

  void setPart(PartFile part){
    assert(_parts[part.id] == null);
    _parts[part.id] = part;
  }

  void updatePartDownloaded(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateDownloaded(value, fromMainThread: true);
  }

  void updatePartEnd(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateEnd(value, fromMainThread: true);
  }

  void updatePartStatus(int id, PartFileStatus value){
    assert(_parts[id] != null);
    _parts[id]!.updateStatus(value, fromMainThread: true);
    print("$id $value");
  }

  //prevent data race for file creation
  void currentLength(SendPort sendPort) {
    currentLengthSendPorts.add(sendPort);
    currentLengthTimer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (currentLengthSendPorts.isNotEmpty) {
        var sendPort = currentLengthSendPorts.removeAt(0);
        sendPort.send([SendPortStatus.currentLength, _parts.length]);
      }
    });
   }


  List<PartFile> get parts => _parts.values.toList();

  void updateStatus(DownloadStatus status) {
    _status = status;
  }

  DownloadStatus get status => _status;

}