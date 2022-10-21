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

  static final Map<int, DownloadController> _controllers = {};

  static Future<void> init() async {
    await EasyDownloadNotification.init();
    await StorageManager().init();
  }

  Future<int> download(String url, String path, String filename, {DownloadMonitor? monitor, DownloadController? downloadController, Map<String, String>? headers}) async {
    Download? download;
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
    isolateListen(receivePort, info, monitor, download, (p0) {
      download = p0;
      _controllers[download!.downloadId] = controller;
      if (downloadController != null) {
        downloadController._pause = controller._pause;
        downloadController._resume = controller._resume;
      }
      completer.complete(download!.downloadId);
    });
    controller._pause = (){
      assert(download != null);
      print("pause");
      download!.pause();
    };
    controller._resume = () async{
      assert(download != null);
      receivePort.close();
      download!.updateStatus(DownloadStatus.downloading);
      print("resume ${download!.parts.length}");
      for(var value in download!.parts){
        if (value.mustRetry())value.updateStatus(PartFileStatus.resumed, fromMainThread: true);
      }
      //receivePort = resumeIsolate();
      receivePort = ReceivePort();
      //receivePort.sendPort.send(receivePort.sendPort);

      download!.updateMainSendPort(receivePort.sendPort);
      isolateListen(receivePort, info, monitor, download, (p0) => download = p0,);
      for (var part in download!.parts){
        part.retry(info);
      }
      //receivePort.sendPort.send([SendPortStatus.updateMainSendPort, receivePort.sendPort, download]);

    };

    return completer.future;
  }

  static List<DownloadTask> get tasks => StorageManager.tasks;

  static DownloadController? getController(int id) {
    return _controllers[id];
  }

  static appendFile(DownloadTask task) => append.appendFile(task);

}