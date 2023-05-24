// Created by linkkader on 4/3/2023

import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader_flutter_lib/data/manager/notification_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

extension EasyDownloaderExt on EasyDownloader {
  Future initFlutter({
    String? localeStoragePath,
    Isar? isar,
    bool allowNotification = false,
    AndroidInitializationSettings? androidInitializationSettings,
    DarwinInitializationSettings? darwinInitializationSettings,
    String? defaultIconAndroid,
  }) async {
    await EasyDownloader()
        .init(isar: isar, localeStoragePath: localeStoragePath);
    if (allowNotification) {
      assert(
          defaultIconAndroid != null || androidInitializationSettings != null,
          'defaultIconAndroid or androidInitializationSettings must be not null');
      await NotificationManager.init(
        androidInitializationSettings: androidInitializationSettings,
        darwinInitializationSettings: darwinInitializationSettings,
        defaultIconAndroid: defaultIconAndroid,
      );
    }
  }
}
