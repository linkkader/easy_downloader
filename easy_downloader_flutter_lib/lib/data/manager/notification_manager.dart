// Created by linkkader on 4/3/2023

import 'package:easy_downloader/easy_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static final Map<int, DownloadTaskListener> _notificationMap = {};

  static _internal() => NotificationManager();
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;

  static bool _isInit = false;

  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init({
    AndroidInitializationSettings? androidInitializationSettings,
    DarwinInitializationSettings? darwinInitializationSettings,
    String? defaultIconAndroid,
  }) async {
    assert(!_isInit, 'NotificationManager already initialized');

    var android = androidInitializationSettings ??
        AndroidInitializationSettings(
          defaultIconAndroid ?? 'ic_launcher',
        );
    var ios =
        darwinInitializationSettings ?? const DarwinInitializationSettings();
    await _notificationPlugin.initialize(
      InitializationSettings(android: android, iOS: ios, macOS: ios),
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    _isInit = true;
  }

  static NotificationDetails _notificationDetail(DownloadTask task) {
    assert(_isInit, 'NotificationManager not initialized');
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'easy_downloader',
        'download notification',
        enableVibration: false,
        progress: task.totalDownloaded,
        maxProgress: task.totalLength,
        visibility: NotificationVisibility.public,
        importance: Importance.low,
        priority: Priority.low,
        showProgress: true,
        onlyAlertOnce: true,
        playSound: false,
        subText: task.fileName,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  static void _updateNotification(DownloadTask task) async {
    assert(_isInit, 'NotificationManager not initialized');
    _notificationPlugin.show(
      task.downloadId,
      task.fileName,
      '${task.status.name} ${task.totalDownloaded.toHumanReadableSize().replaceAll(" ", "")}/${task.totalLength.toHumanReadableSize().replaceAll(" ", "")} (${(task.totalDownloaded * 100) ~/ (task.totalLength == 0 ? 1 : task.totalLength)}%)',
      _notificationDetail(task),
    );
  }

  static void addNotification(DownloadTask task) {
    assert(_isInit, 'NotificationManager not initialized');
    assert(_notificationMap[task.downloadId] == null,
        'Notification already added');
    listener(DownloadTask task) {
      _updateNotification(task);
    }

    _notificationMap[task.downloadId] = listener;
    task.addListener(listener);
  }

  static void removeNotification(DownloadTask task) {
    assert(_isInit, 'NotificationManager not initialized');
    assert(_notificationMap[task.downloadId] != null, 'Notification not added');
    task.removeListener(_notificationMap[task.downloadId]!);
    _notificationMap.remove(task.downloadId);
  }
}

_onDidReceiveNotificationResponse(NotificationResponse payload) {}

onDidReceiveBackgroundNotificationResponse(
    NotificationResponse payload) async {}
