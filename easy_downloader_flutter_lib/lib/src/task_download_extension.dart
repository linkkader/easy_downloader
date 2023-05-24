import 'package:easy_downloader/easy_downloader.dart';
import '../data/manager/notification_manager.dart';

extension TaskExtension on DownloadTask {
  void showNotification() {
    NotificationManager.addNotification(this);
  }

  void hideNotification() {
    NotificationManager.removeNotification(this);
  }
}
