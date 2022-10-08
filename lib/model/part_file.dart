// Created by linkkader on 7/10/2022


import 'dart:isolate';
import 'package:easy_downloader/model/download.dart';
import 'status.dart';

class PartFile{

  SendPort? sendPort;
  late Isolate isolate;
  late final int _start;
  late int _end;
  late final int _id;
  int _downloaded = 0;
  final Download download;
  PartFileStatus _status = PartFileStatus.downloading;

  PartFile({required int start,required int end,required int id, required this.download, required this.isolate}){
    _end = end;
    _start = start;
    _id = id;
  }

  void setSendPort(SendPort sendPort) {
    assert(this.sendPort == null);
    this.sendPort = sendPort;
  }

  void setPartInDownload(){
    assert (sendPort != null);
    download.sendPortMainThread.send([SendPortStatus.setPart, this]);
    download.incrementCurrent();
  }
  void updateEnd(int newEnd, {fromMainThread = false, fromIsolate = false}){
    sendPort?.send("updateEnd  $fromMainThread");
    _end = newEnd;
    if (fromIsolate) return;
    if (!fromMainThread) {
      download.sendPortMainThread.send([SendPortStatus.updatePartEnd, _id, newEnd]);
    }
    else{
      sendPort?.send([SendPortStatus.updatePartEnd, _id, newEnd]);
    }
    //download.sendPort.send([download, updateEnd, _id, newEnd]);
  }

  void updateDownloaded(int value, {bool fromMainThread = false}) {
    _downloaded = value;
    //print('value ${value.toHumanReadableSize()}');
    if (!fromMainThread)download.sendPortMainThread.send([SendPortStatus.updatePartDownloaded, _id, value]);
    //download.sendPort.send([download, updateDownloaded, _id, value]);
  }
  void updateStatus(PartFileStatus value, {bool fromMainThread = false}){
    _status = value;
    if (!fromMainThread) download.sendPortMainThread.send([SendPortStatus.updatePartStatus, _id, value]);
    //download.sendPort.send([download, updateStatus, _id, value]);
  }

  int get start => _start;
  int get end => _end;
  int get id => _id;
  int get downloaded => _downloaded;
  PartFileStatus get status => _status;

}