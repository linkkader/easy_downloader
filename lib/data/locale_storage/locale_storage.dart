// Created by linkkader on 7/10/2022

import 'dart:async';

import 'package:intra_42/data/models/black_hole_data.dart';
import 'package:intra_42/data/models/expertise.dart';
import 'package:intra_42/data/models/scale_team.dart';
import 'package:intra_42/data/models/token_body.dart';
import 'package:intra_42/data/models/user.dart';
import 'package:intra_42/data/models/user_2.dart';
import 'package:intra_42/data/models_izar/expertise_izar.dart';
import 'package:intra_42/data/models_izar/img.dart';
import 'package:intra_42/data/models_izar/notification_isar.dart';
import 'package:intra_42/data/models_izar/pref_isar.dart';
import 'package:intra_42/data/models_izar/scale_team_isar.dart';
import 'package:intra_42/data/models_izar/user2_isar.dart';
import 'package:intra_42/data/models_izar/user_isar.dart';
import 'package:intra_42/main.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/params/constants.dart';
import '../models/user.dart';
import '../models_izar/black_hole.dart';
import '../models_izar/token_body_isar.dart';

class LocaleStorage{
  static const debug = "LocaleStorage:";
  bool _isInit = false;
  LocaleStorage._internal();
  static final instance = LocaleStorage._internal();

  factory LocaleStorage() => instance;
  static late final Isar _isar;

  static isInit() => instance._isInit;

  Future<void> init() async {
    assert(!_isInit, "LocalStorage already initialized");
    _isar = await Isar.open([DateTimeIsarSchema, ExpertiseIsarSchema, IntIsarSchema, StringIsarSchema],);
    _isInit = true;

  }


  static Isar get isar {
    assert(instance._isInit, "LocalStorage not initialized");
    return _isar;
  }

  static DateTime? dateTime(String key) {
    assert(instance._isInit, "LocalStorage not initialized");
    return _isar.dateTimeIsars.where().keyEqualTo(key).findFirstSync()?.value;
  }

  static void setDateTime(String key, DateTime value) async {
    assert(instance._isInit, "LocalStorage not initialized");
    await _isar.writeTxn(() async{
      _isar.dateTimeIsars.put(DateTimeIsar(key, value));
    });
  }

  static int? getInt(String key) {
    assert(instance._isInit, "LocalStorage not initialized");
    return _isar.intIsars.where().keyEqualTo(key).findFirstSync()?.value;
  }

  static Future setInt(String key, int value) async {
    assert(instance._isInit, "LocalStorage not initialized");
    await _isar.writeTxn(() async{
      _isar.intIsars.put(IntIsar(key, value));
    });
  }

  static Future setString(String key, String value) async {
   assert(instance._isInit, "LocalStorage not initialized");
   await _isar.writeTxn(() async{
     _isar.stringIsars.put(StringIsar(key, value));
   });
  }

  static String? getString(String s) {
    assert(instance._isInit, "LocalStorage not initialized");
    return _isar.stringIsars.where().keyEqualTo(s).findFirstSync()?.value;
  }

  static Future<bool> deleteString(String s) async{
    assert(instance._isInit, "LocalStorage not initialized");
    var completer = Completer<bool>();
    await _isar.writeTxn(() async{
      await _isar.stringIsars.where().keyEqualTo(s).deleteFirst();
      completer.complete(true);
    }).catchError((error, stackTrace) {
      App.log.e("$debug deleteString error: $error $stackTrace");
      completer.complete(false);
    });
    return completer.future;
  }

  static Future setDuration(String key,Duration duration){
    assert(instance._isInit, "LocalStorage not initialized");
    return _isar.writeTxn(() async{
      _isar.intIsars.put(IntIsar(key, duration.inMicroseconds));
    });
  }

  static Duration? getDuration(String key){
    assert(instance._isInit, "LocalStorage not initialized");
    var value = _isar.intIsars.where().keyEqualTo(key).findFirstSync()?.value;
    if(value == null) return null;
    return Duration(microseconds: value);
  }

}