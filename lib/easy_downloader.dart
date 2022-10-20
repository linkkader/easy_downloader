// Created by linkkader on 6/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/storage/easy_downloader.dart';
import 'package:easy_downloader/storage/storage_manager.dart';
import 'package:easy_downloader/utils/append_file.dart' as append;
import 'package:easy_downloader/utils/download_isolate.dart';
import 'package:easy_downloader/utils/isolate_listen.dart';
import 'model/download.dart';
import 'model/download_info.dart';
import 'notifications/notification.dart';
import 'storage/status.dart';
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
  Download? _download;

  static Future<void> init() async {
    await EasyDownloadNotification.init();
    await StorageManager().init();
  }

  Future<int> download(String url, String path, String filename, {DownloadMonitor? monitor, DownloadController? downloadController, Map<String, String>? headers}) async {
    var controller = DownloadController();
    var completer = Completer<int>();
    var dir = Directory("$path/.easy_downloader$filename");
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    print(dir.path);
    dir.createSync(recursive: true);
    var receivePort = downloadIsolate();
    var info = DownloadInfo(url, path, headers ?? {}, filename, dir.path);
    isolateListen(receivePort, info, _download, monitor, completer, (p0) => _download = p0,);
    controller._pause = (){
      _download?.pause();
    };
    controller._resume = () async{
      if (_download != null){
        receivePort.close();
        _download!.updateStatus(DownloadStatus.downloading);
        for(var value in _download!.parts){
          if (value.mustRetry())value.updateStatus(PartFileStatus.resumed, fromMainThread: true);
        }
        //receivePort = resumeIsolate();
        receivePort = ReceivePort();

        isolateListen(receivePort, info, _download, monitor, completer, (p0) => _download = p0,);

        //receivePort.sendPort.send(receivePort.sendPort);
        receivePort.sendPort.send([SendPortStatus.updateMainSendPort, receivePort.sendPort, receivePort.sendPort]);
      }
    };

    var id = await completer.future;
    return completer.future;
  }

  static List<DownloadTask> get tasks => StorageManager.tasks;

  static appendFile(DownloadTask task) => append.appendFile(task);


}