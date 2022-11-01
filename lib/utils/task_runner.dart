// Created by linkkader on 21/10/2022
//https://stackoverflow.com/a/62879750/12751927

part of '../easy_downloader.dart';

///queue manager
class TaskRunner {
  final Queue<DownloadTask> _input = Queue();
  late final int maxConcurrentTasks;
  bool _isInit = false;
  int runningTasks = 0;

  static final _instance = TaskRunner._internal();
  TaskRunner._internal();
  factory TaskRunner() => _instance;

  ///init queue manager
  void init({int maxConcurrentTasks = 1, bool startQueue = true}) {
    assert(!_isInit, "TaskRunner already initialized");
    this.maxConcurrentTasks = maxConcurrentTasks;
    _isInit = true;
    var tasks =
        StorageManager.tasks.where((element) => element.isInQueue == true);
    for (var element in tasks) {
      if (startQueue == true) {
        add(element);
      } else {
        _input.add(element);
      }
    }
  }

  ///add task to queue
  void add(DownloadTask value) {
    assert(_isInit, "TaskRunner not initialized");
    for (var element in _input) {
      if (element.downloadId == value.downloadId) {
        return;
      }
    }
    _input.add(value);
    _startExecution();
  }

  ///add multiple tasks to queue
  void addAll(Iterable<DownloadTask> iterable) {
    assert(_isInit, "TaskRunner not initialized");
    for (var element in iterable) {
      add(element);
    }
  }

  Future<void> _startExecution() async {
    log('start execution $runningTasks ${_input.length}',
        name: 'easy_downloader');
    if (runningTasks == maxConcurrentTasks || _input.isEmpty) {
      return;
    }

    if (_input.isNotEmpty && runningTasks < maxConcurrentTasks) {
      runningTasks++;
      log('Concurrent workers: $runningTasks', name: 'easy_downloader');
      var completer = Completer<bool>();
      var task = _input.removeFirst();
      var controller = EasyDownloader.getController(task.downloadId);
      listener(DownloadStatus p0) {
        switch (p0) {
          case DownloadStatus.paused:
            completer.complete(false);
            break;
          case DownloadStatus.completed:
            if (!completer.isCompleted) completer.complete(true);
            break;
          case DownloadStatus.failed:
            completer.complete(false);
            break;
          default:
            break;
        }
      }

      if (controller == null) {
        runningTasks--;
        completer.complete(true);
        return;
      }
      task = EasyDownloader.getTask(task.downloadId)!;
      log('start task ${task.downloadId}', name: 'easy_downloader');
      controller.addStatusListener(listener);
      switch (task.status) {
        case DownloadStatus.queuing:
          controller.start();
          break;
        case DownloadStatus.appending:
          break;
        case DownloadStatus.downloading:
          break;
        case DownloadStatus.paused:
          controller.resume();
          break;
        case DownloadStatus.completed:
          completer.complete(true);
          break;
        case DownloadStatus.failed:
          controller.resume();
          break;
        default:
          break;
      }

      await completer.future;
      controller.removeStatusListener(listener);
      runningTasks--;
      log('task completed $runningTasks', name: 'easy_downloader');
      _startExecution();
    }
  }

  ///remove task from queue
  void remove(int id) {
    assert(_isInit, "TaskRunner not initialized");
    _input.removeWhere((element) => element.downloadId == id);
  }
}
