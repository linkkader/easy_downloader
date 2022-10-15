// Created by linkkader on 7/10/2022

import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/storage/block.dart';
import 'package:easy_downloader/model/download.dart';
import 'status.dart';

class  PartFile{

  SendPort? sendPort;
  late Isolate isolate;
  late final int _start;
  late int _end;
  int _id = 0;
  int _downloaded = 0;
  final Download download;
  PartFileStatus _status = PartFileStatus.downloading;

  PartFile({required int start,required int end,required int id, required this.download, required this.isolate}){
    _end = end;
    _start = start;
    _id = id;
  }

  void setSendPort(SendPort sendPort, {bool updateMainSendPort = false}){
    if (updateMainSendPort != true)assert(this.sendPort == null);
    this.sendPort = sendPort;
  }

  void setPartInDownload(){
    assert (sendPort != null);
    download.sendPortMainThread.send([SendPortStatus.setPart, this]);
    ///download.incrementCurrent();
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
    if (!fromMainThread)download.sendPortMainThread.send([SendPortStatus.updatePartDownloaded, _id, value]);
  }
  void updateStatus(PartFileStatus value, {bool fromMainThread = false}){
    _status = value;
    if (!fromMainThread) download.sendPortMainThread.send([SendPortStatus.updatePartStatus, _id, value]);
  }

  void updateId(int newId) => _id = newId;

  int get start => _start;
  int get end => _end;
  int get id => _id;
  int get downloaded => _downloaded;
  PartFileStatus get status => _status;

  DownloadBlock toDownloadBlock() => DownloadBlock(_id, _start, _end, _downloaded, _status);


  UtilDownload toUtilDownload() => UtilDownload(_start, _end, download, this, id: _id);
}
