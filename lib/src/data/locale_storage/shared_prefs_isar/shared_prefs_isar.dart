// Created by linkkader on 16/2/2023

import 'package:easy_downloader/src/data/locale_storage/shared_prefs_isar/pref_isar.dart';
import 'package:isar/isar.dart';


abstract class SharedPrefsIsar {

  const SharedPrefsIsar(this._isar);

  final Isar? _isar;

  List<CollectionSchema<dynamic>> get defaultPrefsSchemas => [
    DateTimeIsarSchema,
    IntIsarSchema,
    StringIsarSchema
  ];

  DateTime? dateTime(String key) {
    return _isar?.dateTimeIsars.where().keyEqualTo(key).findFirstSync()?.value;
  }

  Future<void> setDateTime(String key, DateTime value) async {
    await _isar?.writeTxn(() async{
      await _isar?.dateTimeIsars.put(DateTimeIsar(key, value));
    });
  }

  int? getInt(String key) {
    return _isar?.intIsars.where().keyEqualTo(key).findFirstSync()?.value;
  }

  Future<void> setInt(String key, int value) async {
    await _isar?.writeTxn(() async{
      await _isar?.intIsars.put(IntIsar(key, value));
    });
  }

  Future<void> setString(String key, String value) async {
    await _isar?.writeTxn(() async{
      await _isar?.stringIsars.put(StringIsar(key, value));
    });
  }

  String? getString(String s) {
    return _isar?.stringIsars.where().keyEqualTo(s).findFirstSync()?.value;
  }

  Future<bool> deleteString(String s) async{
    await _isar?.writeTxn(() async{
      await _isar?.stringIsars.where().keyEqualTo(s).deleteFirst();
    });
    return true;
  }

  Future<int?>? setDuration(String key,Duration duration){
    return _isar?.writeTxn(() async{
      return _isar?.intIsars.put(IntIsar(key, duration.inMicroseconds));
    });
  }

  Duration? getDuration(String key){
    //ignore: lines_longer_than_80_chars
    final value = _isar?.intIsars.where().keyEqualTo(key).findFirstSync()?.value;
    if(value == null) return null;
    return Duration(microseconds: value);
  }
}
