// Created by linkkader on 7/10/2022

import 'dart:async';
import 'dart:isolate';
import 'package:easy_downloader/storage/status.dart';
import 'package:easy_downloader/storage/easy_downloader.dart';
import 'package:easy_downloader/storage/storage_manager.dart';
import 'part_file.dart';

class Download{

  final Map<String, String> headers;
  final String tempPath;
  final String filename;

  //minimum length for part is 2MB
  static const int minimumPartLength = 2 * 1048576;
  int _downloadId = -1;
  late SendPort sendPortMainThread;
  final int totalLength;
  final String path;
  final int maxSplit;
  final List<Isolate> allIsolate = [];
  DownloadStatus _status = DownloadStatus.downloading;
  final Map<int, PartFile> _parts = {};

  Timer? currentLengthTimer;
  List<SendPort> currentLengthSendPorts = [];

  Download({
    required this.totalLength,
    required this.path,
    required this.maxSplit, required this.sendPortMainThread,
    required this.headers,
    required this.tempPath,
    required this.filename
  });

  void setPart(PartFile part){
    if (part.status != PartFileStatus.resumed){
      assert(_parts[part.id] == null);
    }
    if (status != DownloadStatus.downloading){
      part.isolate.kill(priority: Isolate.immediate);
      return;
    }
    _parts[part.id] = part;
    update();
  }

  void updatePartDownloaded(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateDownloaded(value, fromMainThread: true);
    update();
  }

  void updatePartEnd(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateEnd(value, fromMainThread: true);
    update();
  }

  void updatePartIsolate(int id, Isolate value){
    assert(_parts[id] != null);
    _parts[id]!.updateIsolate(value, fromMainThread: true);
    update();
  }

  void updatePartSendPort(int id, SendPort value){
    assert(_parts[id] != null);
    _parts[id]!.updateSendPort(value, fromMainThread: true);
    update();
  }

  // never call in child isolate
  void updateMainSendPort(SendPort sendPort){
    sendPortMainThread = sendPort;
    for(var part in _parts.values){
       part.download = this;
    }
    update();
  }

  void updatePartStatus(int id, PartFileStatus value){
    assert(_parts[id] != null);
    //need optimize sort per max end - start - downloaded
    if (value == PartFileStatus.completed){
      //get max diff id
      var id = -1;
      var diff = 0;
      for(var part in _parts.values){
        if (part.end - part.start - part.downloaded > diff){
          id = part.id;
        }
      }
      //not good
      // if (id != -1){
      //   parts[id].sendPort?.send([SendPortStatus.allowDownloadAnotherPart]);
      // }
    }
    _parts[id]!.updateStatus(value, fromMainThread: true);
    var ss = parts;
    if (ss.isNotEmpty && ss.every((element) => element.status == PartFileStatus.completed)) {
      updateStatus(DownloadStatus.completed);
    }
    update();
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
    update();
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

  Future<int> save() async {
    _downloadId  = await StorageManager().add(_toDownloadTask());
    return _downloadId;
  }

  DownloadTask _toDownloadTask() {
    var downloaded = 0;
    for(var part in parts){
      downloaded += part.downloaded;
    }
    return DownloadTask(
      _downloadId, totalLength,
      path,
      maxSplit,
      status,
      parts.map((e) => e.toDownloadBlock()).toList(),
      downloaded,
      tempPath,
      filename,
      headers,
    );
  }

  void update() {
    assert(-1 != _downloadId);
    StorageManager().update(_downloadId, _toDownloadTask());
  }

  int get downloadId => _downloadId;
}