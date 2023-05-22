// Created by linkkader on 5/3/2023

import 'dart:async';

import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/src/core/utils/task_runner.dart';

/// runner for download task
class Runner {
  Runner._();
  static final Runner _instance = Runner._();
  factory Runner() => _instance;

  static late TaskRunner<DownloadTask> _taskRunner;
  static bool _isInit = false;
  static final Log log = Log();

  static Runner init(){
    assert(!_isInit, 'Runner already initialized');
    _taskRunner = TaskRunner(maxConcurrentTasks: 10, (task, runner) async{
      log.wtf('start task $task');
      var completer = Completer();
      task.addListener((task) {
        if (task.status == DownloadStatus.completed || task.status == DownloadStatus.failed) {
          completer.complete();
        }
      });
      if (task.status == DownloadStatus.queuing){
        task.start();
      }
      else{
        await task.continueDownload();
      }
      await completer.future;
    },);
    _isInit = true;
    return _instance;
  }

  ///add task to runner
  void addTask(DownloadTask task){
    _taskRunner.add(task);
  }

  ///add all task to runner
  void addAllTask(List<DownloadTask> tasks){
    _taskRunner.addAll(tasks);
  }
}