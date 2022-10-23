// Created by linkkader on 7/10/2022

import 'dart:async';
import 'dart:developer';
import '../easy_downloader.dart';
import 'download_monitor.dart';

class DownloadMonitorInside {
  Download download;
  DownloadMonitor? downloadMonitor;
  Timer? timer;
  DownloadMonitorInside(this.download, {this.downloadMonitor});

  void updateDownload(Download download) {
    this.download = download;
  }

  void monitor(){
    log('monitor started', name: 'easy_downloader');
    assert(timer == null);
    if (downloadMonitor == null) return;
    var oldTotalDownloaded = 0;
    Duration duration = const Duration(seconds: 1);
    if (downloadMonitor!.duration != null && duration < downloadMonitor!.duration!) duration = downloadMonitor!.duration!;
    timer = Timer.periodic(duration, (timer) {
      if (download.parts.isNotEmpty) {
        downloadMonitor?.blockMonitor?.call(List.generate(download.parts.length, (index) => download.parts[index].toDownloadBlock()));
      }
      var newTotalDownloaded = 0;
      if (download.parts.isNotEmpty) {
        newTotalDownloaded = download.parts.map((e) => e.downloaded).reduce((value, element) => value + element);
      }
      downloadMonitor?.onProgress?.call(
          newTotalDownloaded,
          download.totalLength,
          (newTotalDownloaded - oldTotalDownloaded) ~/ duration.inSeconds,
          download.status
      );
      oldTotalDownloaded = newTotalDownloaded;
    });
  }

  void dispose(){
    timer?.cancel();
  }
}