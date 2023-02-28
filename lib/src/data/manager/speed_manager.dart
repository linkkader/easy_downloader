
import 'package:easy_downloader/src/core/utils/tupe.dart';
import 'package:easy_downloader/src/data/locale_storage/locale_storage.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';


typedef SpeedListener = int Function(int length);

class SpeedManager {
  factory SpeedManager() => _instance;
  SpeedManager._internal();

  static final Map<
      SpeedListener,
      Tuple<DownloadTaskListener, DownloadTask?, int>> _listeners = {};
  static late LocaleStorage _localeStorage;

  bool _isInit = false;
  static final SpeedManager _instance = SpeedManager._internal();

  static SpeedManager init(LocaleStorage localeStorage) {
    assert(!_instance._isInit, 'SpeedManager already initialized');
    _localeStorage = localeStorage;
    _instance._isInit = true;
    return _instance;
  }

  void addListener(SpeedListener speedListener, int id) {
    void listener(DownloadTask task) {
      final oldTuple = _listeners[speedListener];
      if (oldTuple != null) {
        _listeners[speedListener] = Tuple(oldTuple.first, task, oldTuple.third);
      }
    }
    _localeStorage.addListener(listener, id);
    _listeners[speedListener] = Tuple(listener, null, 0);
  }

  void removeListener(SpeedListener speedListener) {
    final pair = _listeners[speedListener];
    if (pair != null) {
      _localeStorage.removeListener(pair.first);
      _listeners.remove(speedListener);
    }
  }
}
