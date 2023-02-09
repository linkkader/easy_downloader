// Created by linkkader on 6/10/2022

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/storage/easy_downloader.dart';
import 'package:easy_downloader/storage/storage_manager.dart';
import 'package:easy_downloader/utils/download_isolate.dart';
import 'package:easy_downloader/utils/isolate_listen.dart';
import 'model/part_file.dart';
import 'monitor/monitor.dart';
import 'storage/status.dart';
import 'monitor/download_monitor.dart';
import '../utils/append_file.dart';
part 'utils/task_runner.dart';
part 'model/download.dart';

class EasyDownloader {
  static bool _init = false;
  static final Map<int, DownloadController> _controllers = {};

  ///init easy downloader
  static Future<void> init(
      {int maxConcurrentTasks = 4, bool startQueue = false}) async {
    assert(!_init, 'init already called');
    if (maxConcurrentTasks < 1) {
      maxConcurrentTasks = 1;
    }
    await StorageManager().init();
    _init = true;
    TaskRunner()
        .init(maxConcurrentTasks: maxConcurrentTasks, startQueue: startQueue);
  }

  ///get all tasks
  static List<DownloadTask> get tasks => StorageManager.tasks;

  ///get one controller for one task
  static DownloadController? getController(int id, {bool ignoreNull = false}) {
    assert(_init, 'init not called');

    var controller = _controllers[id];
    if (controller == null) {
      if (ignoreNull) return null;
      var task = StorageManager.getTask(id);
      if (task == null) return null;
      controller = DownloadController(id: id);
      var receivePort = ReceivePort();
      controller._updateReceivePort(receivePort);
      controller._updateDownload(task.toDownload(receivePort.sendPort));
      _controllers[id] = controller;
    }
    return controller;
  }

  ///create a new download task
  static Future<DownloadTask> newTask(String url, String path, String filename,
      {Map<String, String>? headers,
      int maxSplit = 8,
      bool showNotification = false}) async {
    assert(_init, 'init not called');
    //delete old temp files
    var dir = Directory("$path/.easy_downloader$filename");
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    var downloadTask = DownloadTask(url, -1, -1, path, maxSplit,
        DownloadStatus.starting, [], 0, dir.path, filename, headers ?? {},
        showNotification: true);
    var id = await StorageManager.box.add(downloadTask);
    downloadTask = downloadTask.copyWith(downloadId: id);
    StorageManager.box.put(id, downloadTask);
    var task = downloadTask;
    late DownloadController controller;
    controller = DownloadController(
      id: id,
      onStart: (monitor) async {},
    );
    EasyDownloader._controllers[id] = controller;
    return task;
  }

  ///remove a task
  static Future<void> delete(int id, {bool deleteFile = false}) async {
    assert(_init, 'init not called');
    var download = StorageManager.box.get(id);
    if (download != null) {
      var dir = Directory(download.tempPath);
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      _controllers.remove(id);
      if (deleteFile) {
        var file = File("${download.path}/${download.filename}");
        file.delete(recursive: true);
      }
      await StorageManager.box.delete(id);
    }
  }

  ///get a task, return null if not exist
  static DownloadTask? getTask(int id) => StorageManager.getTask(id);

  ///add a task to queue
  static void addTaskQueue(int id) {
    assert(_init, 'init not called');
    var task = StorageManager.getTask(id);
    if (task == null) return;
    task = task.copyWith(status: DownloadStatus.queuing, isInQueue: true);
    StorageManager.box.put(id, task);
    TaskRunner().add(task);
  }

  ///remove a task from queue
  static void removeTaskQueue(int id) {
    assert(_init, 'init not called');
    TaskRunner().remove(id);
  }
}
