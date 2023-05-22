
import 'dart:async';

import 'package:easy_downloader/src/core/utils/tupe.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';


typedef SpeedListener = void Function(int length);

/// speed manager
class SpeedManager {
  factory SpeedManager() => _instance;
  SpeedManager._internal();

  static final Map<
      SpeedListener,
      Tuple<DownloadTaskListener, int, int>> _listeners = {};
  static late LocaleStorage _localeStorage;

  bool _isInit = false;
  static final SpeedManager _instance = SpeedManager._internal();

  static SpeedManager init(LocaleStorage localeStorage) {
    assert(!_instance._isInit, 'SpeedManager already initialized');
    _localeStorage = localeStorage;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      for(final listener in _listeners.keys) {
        final tuple = _listeners[listener];
        if (tuple != null) {
          final oldLength = tuple.third;
          var newLength = tuple.second;
          listener(newLength - oldLength);
          _listeners[listener] = Tuple(tuple.first, newLength, newLength);
        }
      }
    });

    _instance._isInit = true;
    return _instance;
  }

  ///add listener
  void addListener(SpeedListener speedListener, int id) {
    assert(_instance._isInit, 'SpeedManager not initialized');
    void listener(DownloadTask task) {
      final oldTuple = _listeners[speedListener];
      if (oldTuple != null) {
        _listeners[speedListener] = Tuple(oldTuple.first, task.totalDownloaded, oldTuple.third);
      }
    }
    _localeStorage.addListener(listener, id);
    _listeners[speedListener] = Tuple(listener, 0, 0);
  }

  ///remove listener
  void removeListener(SpeedListener speedListener) {
    assert(_instance._isInit, 'SpeedManager not initialized');
    final pair = _listeners[speedListener];
    if (pair != null) {
      _localeStorage.removeListener(pair.first);
      _listeners.remove(speedListener);
    }
  }
}
