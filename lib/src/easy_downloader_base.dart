import 'dart:io';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/src/core/extensions/string_ext.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/manager/download_manager.dart';
import 'package:easy_downloader/src/data/manager/isolate_manager.dart';
import 'package:easy_downloader/src/data/manager/runner.dart';
import 'package:isar/isar.dart';
import 'data/locale_storage/storage_model/isar_map_entity.dart';
import 'data/manager/speed_manager.dart';
part 'data/task_extension.dart';

///EasyDownloader
///init EasyDownloader
///example:
///```dart
///await EasyDownloader().init();
///```
///download file
///example:
///```dart
///final task = await EasyDownloader().download(
///    url: 'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4',
///    path: '/storage/emulated/0/Download',
///    fileName: 'test.mp4',
///    maxSplit: 4,
///    autoStart: true,
///    });
///    task.listen((task) {
///     print(task.status);
///    });
///    ```
///    todo: make better documentation
class EasyDownloader {
  factory EasyDownloader() => _instance;
  EasyDownloader._internal();

  static bool _isInit = false;
  static late LocaleStorage _localeStorage;
  static late DownloadManager _downloadManager;
  static late Runner _runner;
  static late SpeedManager _speedManager;
  static final EasyDownloader _instance = EasyDownloader._internal();

  ///init EasyDownloader
  Future<EasyDownloader> init(
      {String? localeStoragePath,
      Isar? isar,
      bool clearLocaleStorage = false}) async {
    assert(!_isInit, 'EasyDownloader already initialized');
    await Isar.initializeIsarCore(download: true);
    localeStoragePath ??= Directory.systemTemp.path;
    _localeStorage = await LocaleStorage.init(
        isar: isar,
        localeStoragePath: localeStoragePath,
        clearLocaleStorage: clearLocaleStorage);
    _speedManager = SpeedManager.init(_localeStorage);
    await IsolateManager.init(
      onFinish: (sendPort) async {
        _downloadManager = DownloadManager.init(sendPort);
      },
    );

    _runner = Runner.init();

    //reset all tasks
    var allTasks = _localeStorage.getDownloadTasks();
    int i = 0;
    for (var task in allTasks) {
      switch (task.status) {
        case DownloadStatus.downloading:
          if (task.inQueue) {
            task = task.copyWith(status: DownloadStatus.paused);
            _runner.addTask(task);
            allTasks[i] = task;
          } else {
            allTasks[allTasks.indexOf(task)] =
                task.copyWith(status: DownloadStatus.paused);
          }
          break;
        case DownloadStatus.queuing:
          _runner.addTask(task);
          break;
        default:
          break;
      }
      i++;
    }
    await _localeStorage.setDownloadTasks(allTasks);
    _isInit = true;
    return _instance;
  }

  ///download file
  Future<DownloadTask> download({
    required String url,
    String? path,
    String? fileName,
    int? maxSplit,
    bool autoStart = false,
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
    var task = DownloadTask(
        url: url,
        path: path,
        fileName: fileName,
        maxSplit: maxSplit ?? 8,
        headers: IsarMapEntity.fromJson(headers));
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

  ///get download task by id
  static EasyDownloader get easyDownloader {
    assert(_isInit, 'EasyDownloader not initialized');
    return _instance;
  }

  static List<CollectionSchema<dynamic>> get schemas => LocaleStorage.schemas;

  ///listen all download tasks
  Stream<void>? get downloadTasksStream => _localeStorage.watchDownloadTasks();

  ///listen download task by id
  Stream<void>? downloadTaskStream(int id) =>
      _localeStorage.watchDownloadTask(id);
}
