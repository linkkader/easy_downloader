// Created by linkkader on 17/2/2023

import 'dart:async';
import 'dart:isolate';

import 'package:easy_downloader/src/core/log/logger.dart';
import 'package:easy_downloader/src/core/utils/pair.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/status.dart';

//main isolate
class DownloadManager{
  factory DownloadManager() => _instance;
  DownloadManager._internal();
  final log = Log();
  static late LocaleStorage _localeStorage;
  static bool _isInit = false;
  static late SendPort _sendPort;
  static final DownloadManager _instance = DownloadManager._internal();

  static DownloadManager init(SendPort sendPort) {
    assert(!_isInit, 'DownloadManager already initialized');
    _sendPort = sendPort;
    _localeStorage = LocaleStorage();
    _isInit = true;
    return _instance;
  }

   Future<void> downloadTask(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    _sendPort.send(Pair(SendPortStatus.download, task));
  }

  Future<void> continueTask(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    _sendPort.send(Pair(SendPortStatus.continueTask, task));
  }

  Future<void> pauseTask(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    _sendPort.send(Pair(SendPortStatus.pauseTask, task));
  }

  Future<void> taskComplete(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    final newTask = task.copyWith(status: DownloadStatus.completed);
    await _localeStorage.setDownloadTask(newTask);
  }

  Future<void> appendSuccess(DownloadTask task) async {
    assert(
      task.status == DownloadStatus.completed,
      'DownloadManager: task status is not success',
    );
    log.info('DownloadManager: appendSuccess  $task');
  }

  bool isAllBlockFinished(DownloadTask task) {
    return task.blocks.every(
          (element) => element.status == BlockStatus.finished,);
  }


  void completeUpdateTask(DownloadTask task, int completerHashcode){
    _sendPort.send(Pair(SendPortStatus.completeUpdateTask,
        Pair(completerHashcode, task),),);
  }

  void completeUpdateBlock(DownloadTask task,
      int completerHashcode, DownloadBlock? block,){
    _sendPort.send(
      Pair(
        SendPortStatus.completeUpdateBlock, Pair(completerHashcode, block,),
      ),
    );
  }

  void blockLength(int completerHashcode, int length){
    _sendPort.send(
      Pair(
        SendPortStatus.blockLength, Pair(completerHashcode, length,),
      ),
    );
  }
}
