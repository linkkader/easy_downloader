// Created by linkkader on 16/2/2023

import 'package:logger/logger.dart';

class Log {

  final log = Logger();
  final _tag = 'EasyDownloader';
  var _infoCount = 0;

  static final Log _instance = Log._internal();
  Log._internal();
  factory Log() => _instance;


  void d(message, [error, StackTrace? stackTrace]) {
    log.d(message, error, stackTrace);
  }

  void e(message, [error, StackTrace? stackTrace]) {
    log.e(message, error, stackTrace);
  }

  void i(message, [error, StackTrace? stackTrace]) {
    log.i(message, error, stackTrace);
  }

  void info(message, [error, StackTrace? stackTrace]) {
    _infoCount++;
    log.i("$_tag: $_infoCount $message", error, stackTrace);
  }


  void v(message, [error, StackTrace? stackTrace]) {
    log.v(message, error, stackTrace);
  }

  void w(message, [error, StackTrace? stackTrace]) {
    log.w(message, error, stackTrace);
  }

  void wtf(message, [error, StackTrace? stackTrace]) {
    log.wtf(message, error, stackTrace);
  }

}
