

import 'dart:io';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/src/core/extensions/string_ext.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/manager/download_manager.dart';
import 'package:easy_downloader/src/data/manager/isolate_manager.dart';
import 'data/locale_storage/storage_model/isar_map_entity.dart';
import 'data/manager/speed_manager.dart';

part 'data/task_extension.dart';

class EasyDownloader {
  factory EasyDownloader() => _instance;
  EasyDownloader._internal();

  static bool _isInit = false;
  static late LocaleStorage _localeStorage;
  static late DownloadManager _downloadManager;
  static late SpeedManager _speedManager;
  static final EasyDownloader _instance = EasyDownloader._internal();

  ///init EasyDownloader
  Future<EasyDownloader> init({String? localeStoragePath, Isar? isar}) async {
    assert(!_isInit, 'EasyDownloader already initialized');
    await Isar.initializeIsarCore(download: true);
    _localeStorage = await LocaleStorage.init(isar: isar, localeStoragePath: localeStoragePath);
    _speedManager = SpeedManager.init(_localeStorage);
    await IsolateManager.init(onFinish: (sendPort) async {
      _downloadManager = DownloadManager.init(sendPort);
    },);
    _isInit = true;
    return _instance;
  }

  ///download file
  Future<DownloadTask> download({
    required String url,
    String? path, String? fileName,
    int? maxSplit,
    bool autoStart = true,
    Map<String, String> headers = const {},
  }) async {
    assert(_isInit, 'EasyDownloader not initialized');
    fileName ??= url.fileNameFromUrl();
    path ??= '.';
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    //ignore: lines_longer_than_80_chars
    var task = DownloadTask(url: url, path: path, fileName: fileName, maxSplit: maxSplit ?? 8, headers: IsarMapEntity.fromJson(headers));
    final id = await _localeStorage.setDownloadTask(task);
    task = task.copyWith(downloadId: id);
    assert(id != null, 'EasyDownloader: id must not be null');
    if (autoStart) {
      await _downloadManager.downloadTask(task);
    }
    return task;
  }

  ///list all download tasks
  Future<List<DownloadTask>> allDownloadTasks() async {
    assert(_isInit, 'EasyDownloader not initialized');
    return _localeStorage.getDownloadTasks();
  }

  static EasyDownloader get easyDownloader {
    assert(_isInit, 'EasyDownloader not initialized');
    return _instance;
  }

  static List<CollectionSchema<dynamic>> get schemas => LocaleStorage.schemas;
}
