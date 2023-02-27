

import 'dart:io';
import 'package:easy_downloader/src/core/extensions/string_ext.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/manager/speed_manager.dart';
import 'package:isar/isar.dart';
import 'core/log/logger.dart';
import 'data/locale_storage/storage_model/download_task.dart';
import 'data/locale_storage/storage_model/status.dart';
import 'data/manager/download_manager.dart';
import 'data/manager/isolate_manager.dart';


part 'data/task_extension.dart';

class EasyDownloader {
  factory EasyDownloader() => _instance;
  EasyDownloader._internal();

  final Log _log = Log();
  bool _isInit = false;
  static late LocaleStorage _localeStorage;
  static late DownloadManager _downloadManager;
  static late SpeedManager _speedManager;

  static EasyDownloader _instance = EasyDownloader._internal();

  Future<EasyDownloader> init() async {
    assert(!_isInit, 'EasyDownloader already initialized');
    await Isar.initializeIsarCore(download: true);
    _localeStorage = await LocaleStorage.init();
    // _speedManager = SpeedManager.init(_localeStorage);
    print('EasyDownloader init');

    _instance = EasyDownloader._internal();
    await IsolateManager.init(onFinish: (sendPort) async {
      _downloadManager = DownloadManager.init(sendPort);
    },);
    _isInit = true;
    return this;
  }

  Future<DownloadTask> download({
    required String url,
    String? path, String? fileName,
    int? maxSplit,
    DownloadTaskListener? listener,
    bool autoStart = true,
    // SpeedListener? speedListener,
  }) async {
    assert(_isInit, 'EasyDownloader not initialized');
    fileName ??= url.fileNameFromUrl();
    path ??= '.';
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    var task = DownloadTask(url: url, path: path, fileName: fileName, maxSplit: maxSplit ?? 8);
    final id = await _localeStorage.setDownloadTask(task);
    task = task.copyWith(downloadId: id);
    assert(id != null, 'EasyDownloader: id must not be null');
    if (autoStart) {
      _downloadManager.downloadTask(task);
    }
    if (listener != null) {
      _localeStorage.addListener(listener, id!);
    }
    // if (speedListener != null) {
    //   _speedManager.addListener(speedListener, id!);
    // }
    return task;
  }

  Future<List<DownloadTask>> allDownloadTasks() async {
    assert(_isInit, 'EasyDownloader not initialized');
    return _localeStorage.getDownloadTasks();
  }

  static EasyDownloader get easyDownloader {
    assert(_instance._isInit, 'EasyDownloader not initialized');
    return _instance;
  }

}