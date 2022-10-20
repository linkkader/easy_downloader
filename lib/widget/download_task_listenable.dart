// Created by linkkader on 20/10/2022

import 'package:easy_downloader/storage/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../storage/easy_downloader.dart';

class EasyDownloadTaskListenable extends StatelessWidget {
  final int downloadId;
  final Widget Function(BuildContext context, DownloadTask task) builder;
  const EasyDownloadTaskListenable(this.downloadId, this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: StorageManager.box.listenable(keys: [downloadId]), builder: (context, Box<DownloadTask> box, child) {
      var task = box.get(downloadId);
      assert(task != null);
      return builder(context, task!);
    });
  }
}
