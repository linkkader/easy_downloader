// Created by linkkader on 16/2/2023

import 'dart:async';
import 'dart:isolate';
import 'package:easy_downloader/src/core/log/logger.dart';
import 'package:easy_downloader/src/core/utils/pair.dart';
import 'package:easy_downloader/src/core/utils/tupe.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';
import 'package:easy_downloader/src/data/manager/download_manager.dart';
import '../../core/enum/send_port_status.dart';
import '../locale_storage/storage_model/status.dart';
import 'download_manager_isolate.dart';

class IsolateManager{
  factory IsolateManager() => _instance;
  IsolateManager._internal();

  static Log log = Log();
  static DownloadManager downloadManager = DownloadManager();
  static final Completer<SendPort> _sendPortCompleter = Completer();
  static late LocaleStorage _localeStorage;

  static bool _isInit = false;
  static final IsolateManager _instance = IsolateManager._internal();

  static Future<IsolateManager> init(
      {Future<dynamic> Function(SendPort sendPort)? onFinish,})
  async {
    assert(!_isInit, 'IsolateManager already initialized');
    final receivePort = ReceivePort();
    _localeStorage = LocaleStorage();
    await Isolate.spawn(_isolateEntry, receivePort.sendPort);
    receivePort.listen(_isolateListen);
    await onFinish?.call(await _sendPortCompleter.future);
    log.info('IsolateManager initialized success');
    _isInit = true;
    return _instance;
  }

  //in isolate
  static dynamic _isolateEntry(SendPort sendPort) async {
    final receivePort = ReceivePort();
    final downloadManagerIsolate = DownloadManagerIsolate.init(sendPort);
    sendPort.send(
        Pair(SendPortStatus.updateMainIsolateSendPort, receivePort.sendPort),
    );
    receivePort.listen((message) async {
      final pair = message as Pair<SendPortStatus, dynamic>;
      switch(pair.first){
        case SendPortStatus.download:
          assert(
            pair.second is DownloadTask,
            'IsolateManager: pair.second is not DownloadTask',
          );
          final task = pair.second as DownloadTask;
          await downloadManagerIsolate.downloadTask(task);
          break;
        case SendPortStatus.completeUpdateTask:
          //ignore: lines_longer_than_80_chars
          assert(pair.second is Pair, 'IsolateManager: pair.second is not Pair');
          /// completer hashcode and download task from main isolate
          final data = pair.second as Pair<int, DownloadTask>;
          downloadManagerIsolate.continueCompleter(data.first, data.second);
          break;
        case SendPortStatus.completeUpdateBlock:
          assert(pair.second is Pair, 'IsolateManager: pair.second is not Pair');
          var data = pair.second as Pair<int, DownloadBlock?>;
          downloadManagerIsolate.continueCompleter(data.first, data.second);
          break;
        case SendPortStatus.blockLength:
          //ignore: lines_longer_than_80_chars
          assert(pair.second is Pair<int, int>, 'IsolateManager: pair.second is not Pair<int, int>');
          final data = pair.second as Pair<int, int>;
          downloadManagerIsolate.continueCompleter(data.first, data.second);
          break;
        case SendPortStatus.pauseTask:
          //ignore: lines_longer_than_80_chars
          assert(pair.second is DownloadTask, 'IsolateManager: pair.second is not DownloadTask');
          final task = pair.second as DownloadTask;
          await downloadManagerIsolate.pauseTask(task);
          break;
        case SendPortStatus.continueTask:
          //ignore: lines_longer_than_80_chars
          assert(pair.second is DownloadTask, 'IsolateManager: pair.second is not DownloadTask');
          final task = pair.second as DownloadTask;
          await downloadManagerIsolate.continueTask(task);
          break;
        default:
          throw Exception('IsolateManager: unknown SendPortStatus ${pair.first}');
      }
    });
  }

  //in main isolate || outside isolate
  static dynamic _isolateListen(dynamic message) async {
    assert(message is Pair, 'IsolateManager: message is not Pair');
    final pair = message as Pair<SendPortStatus, dynamic>;
    switch(pair.first){
      case SendPortStatus.updateMainIsolateSendPort:
        //ignore: lines_longer_than_80_chars
        assert(pair.second is SendPort, 'IsolateManager: pair.second is not SendPort');
        _sendPortCompleter.complete(pair.second as SendPort);
        break;

        ///task and and completer hascode from isolate
      case SendPortStatus.updateTask:
        //ignore: lines_longer_than_80_chars
        assert(pair.second is Pair<DownloadTask, int>, 'IsolateManager: pair.second is not Pair<DownloadTask, int>');
        final data = pair.second as Pair<DownloadTask, int>;
        final id = await _localeStorage.setDownloadTask(data.first);
        assert(id != null, 'IsolateManager: id is null');
        final task = _localeStorage.getDownloadTaskSync(id!);
        assert(task != null, 'IsolateManager: task is null');
        downloadManager.completeUpdateTask(task!, data.second);
        break;
      case SendPortStatus.updateBlock:
        //ignore: lines_longer_than_80_chars
        assert(pair.second is Tuple<DownloadTask, DownloadBlock, int>, 'IsolateManager: pair.second is not Tuple<DownloadTask, DownloadBlock, int>');
        final data = pair.second as Tuple<DownloadTask, DownloadBlock, int>;
        //ignore: lines_longer_than_80_chars
        final block = await _localeStorage.updateBlock(data.first.downloadId, data.second);
        downloadManager.completeUpdateBlock(data.first, data.third, block);
        break;
      case SendPortStatus.blockFinished:
        assert(_isInit == true, 'IsolateManager: not initialized');
        assert(pair.second is Pair<DownloadTask, DownloadBlock>, 'IsolateManager: pair.second is pair<DownloadTask, DownloadBlock>');
        final data = pair.second as Pair<DownloadTask, DownloadBlock>;
        final task = _localeStorage.getDownloadTaskSync(data.first.downloadId);
        if (downloadManager.isAllBlockFinished(task!))
        {
          await downloadManager.taskComplete(task);
        }
        break;
      case SendPortStatus.blockLength:
        //ignore: lines_longer_than_80_chars
        assert(pair.second is Pair<DownloadTask, int>, 'IsolateManager: pair.second is not Pair<DownloadTask, int>');
        final data = pair.second as Pair<DownloadTask, int>;
        final task = _localeStorage.getDownloadTaskSync(data.first.downloadId);
        assert(task != null, 'IsolateManager: task is null');
        downloadManager.blockLength(data.second, task!.blocks.length);
        break;
      case SendPortStatus.pauseTaskSuccess:
        //ignore: lines_longer_than_80_chars
        assert(pair.second is DownloadTask, 'IsolateManager: pair.second is not DownloadTask');
        var task = pair.second as DownloadTask;
        task = task.copyWith(status: DownloadStatus.paused);
        await _localeStorage.setDownloadTask(task);
        break;
      case SendPortStatus.continueTaskSuccess:
        //ignore: lines_longer_than_80_chars
        assert(pair.second is DownloadTask, 'IsolateManager: pair.second is not DownloadTask');
        final task = pair.second as DownloadTask;
        log.e(task);
        await _localeStorage.setDownloadTaskStatus(
          task.downloadId, DownloadStatus.downloading,
        );
        break;
      default:
        throw Exception("IsolateManager: unknown SendPortStatus");
    }
  }


}