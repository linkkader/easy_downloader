// Created by linkkader on 11/10/2022

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EasyDownloadNotification {

  static final _notificationPlugin = FlutterLocalNotificationsPlugin();
  static int _id = 0;

  static final EasyDownloadNotification _instance = EasyDownloadNotification._();
  EasyDownloadNotification._();
  factory EasyDownloadNotification() => _instance;


  static init(){
    const android = AndroidInitializationSettings('waifu');
    const ios = DarwinInitializationSettings();
    _notificationPlugin.initialize(const InitializationSettings(android: android, iOS: ios));

    // IOSNotificationDetails iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentSound: true, badgeNumber: 1,presentAlert: true,presentBadge: true);
    // var notif = AndroidNotificationDetails("Notification New Anime",
    //     "Notification New Anime",priority: Priority.max,playSound: true,enableVibration: true,indeterminate: true,
    //     importance: Importance.max,
    //     //icon: animeInfo?.img,
    //     fullScreenIntent: true,largeIcon:   data != null ? ByteArrayAndroidBitmap(Uint8List.fromList(data)) : null);
    // var channelSpecific = NotificationDetails(android: notif,iOS: iOSPlatformChannelSpecifics);
    // final notificationPlugin = FlutterLocalNotificationsPlugin();
    // await notificationPlugin.show(i, "New Anime: "+anime.name, anime.name, channelSpecific,payload: AnimeToJson(anime));
  }

  static NotificationDetails _notificationDetail(){
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'easy_downloader',
          'download notification',
          progress: 50,
          visibility: NotificationVisibility.private,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: 100,
        ),
        iOS: DarwinNotificationDetails(

        )
    );
  }

  static void showNotification(String title, String body) {
    print(_id);
    _notificationPlugin.show(_id++, title, body, _notificationDetail());
  }
}