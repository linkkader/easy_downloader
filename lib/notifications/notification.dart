// Created by linkkader on 11/10/2022


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../easy_downloader.dart';
import '../storage/easy_downloader.dart';

class EasyDownloadNotification {

  static bool isInit = false;
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();
  static final EasyDownloadNotification _instance = EasyDownloadNotification._();
  EasyDownloadNotification._();
  factory EasyDownloadNotification() => _instance;


  static init(){
    const android = AndroidInitializationSettings('waifu');
    const ios = DarwinInitializationSettings();
    _notificationPlugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (payload) {
        if (payload.id != null){
          EasyDownloader.openFile(payload.id!);
        }
      },
      onDidReceiveBackgroundNotificationResponse: (payload) async {
        if (payload.id != null){
          EasyDownloader.openFile(payload.id!);
        }
        },
    );
    isInit = true;
  }

  static NotificationDetails _notificationDetail(DownloadTask task) {
    return NotificationDetails(
        android: AndroidNotificationDetails(
          'easy_downloader',
          'download notification',
          enableVibration: false,
          progress: task.downloaded,
          visibility: NotificationVisibility.public,
          importance: Importance.low,
          priority: Priority.low,
          showProgress: true,
          maxProgress: task.totalLength,
          onlyAlertOnce: true,
          playSound: false,
        ),
        iOS: const DarwinNotificationDetails(

        ),
    );
  }

  static void showNotification(DownloadTask task) async {
    if (!isInit) return;
    _notificationPlugin.show(
        task.downloadId,
        task.filename,
        task.status.name,
        _notificationDetail(task),
    );
  }
}