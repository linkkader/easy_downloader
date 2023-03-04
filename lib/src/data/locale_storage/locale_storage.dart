// Created by linkkader on 7/10/2022

import 'dart:async';
import 'dart:math';
import 'package:easy_downloader/src/core/log/logger.dart';
import 'package:easy_downloader/src/data/locale_storage/shared_prefs_isar/shared_prefs_isar.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/status.dart';
import 'package:isar/isar.dart';

class LocaleStorage extends SharedPrefsIsar {
  factory LocaleStorage() => _instance;
  LocaleStorage._internal() : super(_isar);
  final Map<
      void Function(DownloadTask task),
      StreamSubscription<DownloadTask?>?> _listeners = {};
  final _log = Log();
  static bool _isInit = false;
  static Isar? _isar;
  static final LocaleStorage _instance = LocaleStorage._internal();

  static List<CollectionSchema<dynamic>> schemas = [
    ..._instance.defaultPrefsSchemas,
    DownloadTaskSchema
  ];

  static Future<LocaleStorage> init({String? localeStoragePath, Isar? isar}) async {
    assert(!_isInit, 'LocaleStorage already initialized');
    _isar = isar;
    _isar ??= await Isar.open(
        [
          ..._instance.defaultPrefsSchemas,
          DownloadTaskSchema
        ],
        directory: localeStoragePath
    );
    _isInit = true;
    _instance._log.info('LocaleStorage initialized successfully');
    return _instance;
  }

  LocaleStorage get instance => _instance;

  //return download task by id
  Future<int?> setDownloadTask(DownloadTask task) async {
    return _isar?.writeTxn(() async {
      return _isar?.downloadTasks.put(task);
    });
  }


  Future<int?> setDownloadTaskStatus(int id, DownloadStatus status) async {
    return _isar?.writeTxn(() async {
      var task = await _isar?.downloadTasks.get(id);
      assert(task != null, 'Download task not found');
      task = task!.copyWith(status: status);
      return _isar?.downloadTasks.put(task);
    });
  }

  List<DownloadTask> getDownloadTasks() {
    return _isar?.downloadTasks.where().findAllSync() ?? [];
  }

  DownloadTask? getDownloadTaskSync(int id) {
    return _isar?.downloadTasks.getSync(id);
  }


  Future<DownloadTask?>? getDownloadTask(int id) {
    return _isar?.downloadTasks.get(id);
  }



  Future<bool?> deleteDownloadTask(int id) async {
    return _isar?.writeTxn(() async {
      return _isar?.downloadTasks.delete(id);
    });
  }


  Future<DownloadBlock?> updateBlock(int downloadId,
      DownloadBlock downloadBlock,) async{
    var block = downloadBlock;
    block = block.copyWith(
      downloaded: min(block.downloaded, block.end - block.start),
    );
    return _isar?.writeTxn(() async {
      var task = await _isar?.downloadTasks.get(downloadId);
      assert(
        task?.status != DownloadStatus.completed,
        'Download task already completed',
      );
      assert(task != null, 'Download task not found');
      if (block.currentSplit > task!.maxSplit){
        throw Exception('Block split is greater than max split');
      }

      final index = task.blocks.indexWhere((element) => element.id == block.id);
      if (index == -1) {
        var id = 0;
        for (final element in task.blocks) {
          id = max(id, element.id);
        }
        block = block.copyWith(id: id + 1,
            currentSplit: task.blocks.length + 1,);
        task = task.copyWith(blocks: [...task.blocks, block]);
        if (block.currentSplit > task.maxSplit){
          return null;
        }
      }
      else {
        if ((
            block.downloaded > task.blocks[index].downloaded)
              || block.status != BlockStatus.downloading)
        {
          task.blocks[index] = block;
        }
      }
      task = task.copyWith(totalDownloaded: task.blocks.fold(0,
              (previousValue, element) => previousValue! + element.downloaded,),
      );
      return _isar?.downloadTasks.put(task).then((value) {
        return block;
      });
    });
  }

  void addListener(DownloadTaskListener listener, int id) {
    _listeners[listener] = _isar?.downloadTasks
        .watchObject(id, fireImmediately: true).listen((event) {
          if (event != null) {
            listener(event);
          }},
    );
  }

  void removeListener(DownloadTaskListener listener) {
    _listeners[listener]?.cancel();
    _listeners.remove(listener);
  }

  static Isar? get isar => _isar;
}
