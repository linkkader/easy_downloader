// Created by linkkader on 16/2/2023

import 'package:easy_downloader/src/data/locale_storage/shared_prefs_isar/pref_isar.dart';
import 'package:isar/isar.dart';

///class to store key value pair for date time
///[key] key
///[value] value
///[id] id
///[DateTimeIsar] date time isar
///[IntIsar] int isar
///[StringIsar] string isar
///[SharedPrefsIsar] shared prefs isar
///[defaultPrefsSchemas] default prefs schemas
///[dateTime] date time
///[setDateTime] set date time
///[getInt] get int
///[setInt] set int
abstract class SharedPrefsIsar {
  const SharedPrefsIsar(this._isar);

  final Isar? _isar;

  List<CollectionSchema<dynamic>> get defaultPrefsSchemas => [
        DateTimeIsarEasyDownloaderSchema,
        IntIsarEasyDownloaderSchema,
        StringIsarEasyDownloaderSchema
      ];

  ///return date time value for given key
  DateTime? dateTime(String key) {
    return _isar?.dateTimeIsarEasyDownloaders
        .where()
        .keyEqualTo(key)
        .findFirstSync()
        ?.value;
  }

  ///set date time value for given key
  Future<void> setDateTime(String key, DateTime value) async {
    await _isar?.writeTxn(() async {
      await _isar?.dateTimeIsarEasyDownloaders
          .put(DateTimeIsarEasyDownloader(key, value));
    });
  }

  ///return int value for given key
  int? getInt(String key) {
    return _isar?.intIsarEasyDownloaders
        .where()
        .keyEqualTo(key)
        .findFirstSync()
        ?.value;
  }

  ///set int value for given key
  Future<void> setInt(String key, int value) async {
    await _isar?.writeTxn(() async {
      await _isar?.intIsarEasyDownloaders
          .put(IntIsarEasyDownloader(key, value));
    });
  }

  ///return string value for given key
  Future<void> setString(String key, String value) async {
    await _isar?.writeTxn(() async {
      await _isar?.stringIsarEasyDownloaders
          .put(StringIsarEasyDownloader(key, value));
    });
  }

  ///set string value for given key
  String? getString(String s) {
    return _isar?.stringIsarEasyDownloaders
        .where()
        .keyEqualTo(s)
        .findFirstSync()
        ?.value;
  }

  ///delete date time value for given key
  Future<bool> deleteString(String s) async {
    await _isar?.writeTxn(() async {
      await _isar?.stringIsarEasyDownloaders
          .where()
          .keyEqualTo(s)
          .deleteFirst();
    });
    return true;
  }

  ///delete int value for given key
  Future<int?>? setDuration(String key, Duration duration) {
    return _isar?.writeTxn(() async {
      return _isar?.intIsarEasyDownloaders
          .put(IntIsarEasyDownloader(key, duration.inMicroseconds));
    });
  }

  ///delete date time value for given key
  Duration? getDuration(String key) {
    //ignore: lines_longer_than_80_chars
    final value = _isar?.intIsarEasyDownloaders
        .where()
        .keyEqualTo(key)
        .findFirstSync()
        ?.value;
    if (value == null) return null;
    return Duration(microseconds: value);
  }
}
