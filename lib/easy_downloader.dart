// Created by linkkader on 6/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/utils/download_isolate.dart';
import 'package:easy_downloader/utils/isolate_listen.dart';
import 'package:easy_downloader/utils/resume_isolate.dart';
import 'model/download.dart';
import 'model/download_info.dart';
import 'model/status.dart';
import 'monitor/download_monitor.dart';

class DownloadController {

  Function? _pause;
  Function? _resume;

  void pause(){
    _pause?.call();
  }

  void resume(){
    _resume?.call();
  }

}

class EasyDownloader {
  late String url;
  Download? _download;

  Future<void> download(String url, String path, {DownloadMonitor? monitor, DownloadController? downloadController}) async {
    var dir = Directory(path);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync();
    this.url = url;
    var receivePort = downloadIsolate();
    var info = DownloadInfo(url, path, {});
    isolateListen(receivePort, info, downloadController, _download, monitor, (p0) => _download = p0,);
    downloadController?._pause = (){
      _download?.pause();
    };
    downloadController?._resume = () async{
      if (_download != null){
        receivePort.close();
        _download!.updateStatus(DownloadStatus.downloading);
        for(var value in _download!.parts){
          if (value.mustRetry())value.updateStatus(PartFileStatus.resumed, fromMainThread: true);
        }
        //receivePort = resumeIsolate();
        receivePort = ReceivePort();

        isolateListen(receivePort, info, downloadController, _download, monitor, (p0) => _download = p0,);

        //receivePort.sendPort.send(receivePort.sendPort);
        receivePort.sendPort.send([SendPortStatus.updateMainSendPort, receivePort.sendPort, receivePort.sendPort]);
      }
    };
  }

}