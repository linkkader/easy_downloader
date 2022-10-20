// Created by linkkader on 12/10/2022

import 'dart:io';
import 'package:easy_downloader/storage/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'block.dart';
import 'easy_downloader.dart';

class StorageManager{
  static final StorageManager _instance = StorageManager._internal();
  StorageManager._internal();
  factory StorageManager() => _instance;
  bool _isInit = false;

  static late Box<DownloadTask> _box;

  Future init() async {
    assert(!_isInit, "StorageManager already initialized");
    Directory appDocumentDir = await path.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(DownloadTaskAdapter());
    Hive.registerAdapter(DownloadBlockAdapter());
    Hive.registerAdapter(DownloadStatusAdapter());
    Hive.registerAdapter(PartFileStatusAdapter());
    Hive.registerAdapter(SendPortStatusAdapter());
    _box = await Hive.openBox<DownloadTask>("easy_downloader");
    _isInit = true;
  }

  //add
  Future<int> add(DownloadTask easyDownloader) async {
    assert(_isInit, "StorageManager not initialized");
    var key = await _box.add(easyDownloader);
    await _box.put(key, easyDownloader.copyWith(downloadId: key));
    assert(key != -1);
    return key;
  }

  //delete
  Future<void> delete(int key) async {
    assert(_isInit, "StorageManager not initialized");
    await _box.delete(key);
  }

  void update(int key, DownloadTask easyDownloader) async {
    assert(_isInit, "StorageManager not initialized");
    assert(key != -1);
    await _box.put(key, easyDownloader);
  }

  static List<DownloadTask> get tasks => _box.values.toList();

  static DownloadTask? getTask(int key) => _box.get(key);

  static Box<DownloadTask> get box => _box;
}