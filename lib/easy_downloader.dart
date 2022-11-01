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

///controller for one task
class DownloadController {
  final List<Function(DownloadStatus)> _statusListeners = [];

  Download? _download;
  DownloadMonitor? _monitor;
  ReceivePort? _receivePort;
  final Function(DownloadMonitor? monitor)? onStart;
  final int id;
  DownloadController({required this.id, this.onStart});

  void pause() {
    assert(_download != null);
    switch (_download!.status) {
      case DownloadStatus.completed:
        log('already completed', name: 'easy_downloader');
        return;
      case DownloadStatus.paused:
        log('already paused', name: 'easy_downloader');
        return;
      case DownloadStatus.appending:
        log('in appending', name: 'easy_downloader');
        return;
      case DownloadStatus.queuing:
        log('in queuing', name: 'easy_downloader');
        return;
      default:
        break;
    }
    _download!.pause();
    var task = _download!.toTask();
    if (task.isInQueue) {
      EasyDownloader.removeTaskQueue(task.downloadId);
    }
  }

  void resume() {
    log('resume', name: 'easy_downloader');
    assert(_download != null && _download!.downloadId != -1);
    switch (_download!.status) {
      case DownloadStatus.downloading:
        log('already downloading', name: 'easy_downloader');
        return;
      case DownloadStatus.completed:
        log('already completed', name: 'easy_downloader');
        return;
      case DownloadStatus.appending:
        log('in appending', name: 'easy_downloader');
        return;
      case DownloadStatus.queuing:
        log('in queuing', name: 'easy_downloader');
        return;
      default:
        break;
    }
    _receivePort?.close();
    _download!.updateStatus(DownloadStatus.downloading);
    for (var value in _download!.parts) {
      if (value.mustRetry()) {
        value.updateStatus(PartFileStatus.resumed, fromMainThread: true);
      }
    }
    _receivePort = ReceivePort();
    _download!.updateMainSendPort(_receivePort!.sendPort);
    var task = _download!.toTask();
    isolateListen(
      _receivePort!,
      task,
      _monitor,
      _download!,
      (p0) => _download = p0,
    );
    for (var part in _download!.parts) {
      part.retry(task);
    }
    if (task.isInQueue) {
      EasyDownloader.addTaskQueue(task.downloadId);
    }
  }

  void start({DownloadMonitor? monitor}) {
    if (_download == null ||
        _download?.status == DownloadStatus.starting ||
        _download?.status == DownloadStatus.queuing) {
      var receivePort = downloadIsolate();
      var task = EasyDownloader.getTask(id);
      if (task == null) {
        log('task is null', name: 'easy_downloader');
        return;
      }
      _download ??= task.toDownload(receivePort.sendPort);
      _updateMonitor(monitor);
      _updateReceivePort(receivePort);
      isolateListen(receivePort, task, monitor, _download!, (p0) {
        _download = p0;
        _updateDownload(_download!);
      });
    } else {
      log('start already called ', name: 'easy_downloader');
    }
  }

  int get downloadId => id;

  void _updateDownload(Download download) {
    _download = download;
  }

  void _updateMonitor(DownloadMonitor? monitor) {
    _monitor = monitor;
  }

  void _updateReceivePort(ReceivePort receivePort) {
    _receivePort = receivePort;
  }

  void addStatusListener(Function(DownloadStatus) listener) {
    _statusListeners.add(listener);
  }

  void removeStatusListener(Function(DownloadStatus) listener) {
    _statusListeners.remove(listener);
  }
}

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
