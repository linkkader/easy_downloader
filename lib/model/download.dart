// Created by linkkader on 7/10/2022

import 'dart:async';
import 'dart:isolate';
import 'package:easy_downloader/model/status.dart';
import 'part_file.dart';

class Download{

  //minimum length for part is 2MB
  static const int minimumPartLength = 2 * 1048576;

  late SendPort sendPortMainThread;
  final int totalLength;
  final String path;
  final int maxSplit;
  final List<Isolate> allIsolate = [];
  DownloadStatus _status = DownloadStatus.downloading;
  final Map<int, PartFile> _parts = {};

  Timer? currentLengthTimer;
  List<SendPort> currentLengthSendPorts = [];

  Download({required this.totalLength,required this.path, required this.maxSplit, required this.sendPortMainThread});

  void setPart(PartFile part){
    if (part.status != PartFileStatus.resumed){
      assert(_parts[part.id] == null);
    }
    if (status != DownloadStatus.downloading){
      part.isolate.kill(priority: Isolate.immediate);
      return;
    }
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

  void updatePartIsolate(int id, Isolate value){
    assert(_parts[id] != null);
    _parts[id]!.updateIsolate(value, fromMainThread: true);
  }

  void updatePartSendPort(int id, SendPort value){
    assert(_parts[id] != null);
    _parts[id]!.updateSendPort(value, fromMainThread: true);
  }

  // never call in child isolate
  void updateMainSendPort(SendPort sendPort){
    sendPortMainThread = sendPort;
    for(var part in _parts.values){
       part.download = this;
    }
  }

  void updatePartStatus(int id, PartFileStatus value){
    assert(_parts[id] != null);
    //need optimize sort per max end - start - downloaded
    if (value == PartFileStatus.completed){
      for (var part in parts){
        part.sendPort?.send([SendPortStatus.allowDownloadAnotherPart]);
      }
    }
    _parts[id]!.updateStatus(value, fromMainThread: true);
    print("$id $value");
  }

  //prevent data race for file creation
  //need dispose
  void currentLength(SendPort sendPort) {
    currentLengthSendPorts.add(sendPort);
    currentLengthTimer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (currentLengthSendPorts.isNotEmpty) {
        var sendPort = currentLengthSendPorts.removeAt(0);
        var length =  _parts.length;
        var downloading = 0;
        for (var part in _parts.values) {
          if (part.status != PartFileStatus.completed) {
            downloading++;
          }
        }
        if (downloading >= maxSplit) {
          length = -1;
        }
        if (status != DownloadStatus.downloading) {
          length = -1;
        }
        sendPort.send([SendPortStatus.currentLength, length]);
      }
    });
   }


  List<PartFile> get parts => _parts.values.toList();

  void updateStatus(DownloadStatus status) {
    _status = status;
  }

  DownloadStatus get status => _status;

  void pause(){
    for(var value in parts){
      if (value.status == PartFileStatus.downloading){
        value.sendPort?.send([SendPortStatus.pausePart]);
      }
      updateStatus(DownloadStatus.paused);
    }
  }

  void addChildren(Isolate isolate) {
    allIsolate.add(isolate);
  }

}