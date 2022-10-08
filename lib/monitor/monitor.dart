// Created by linkkader on 7/10/2022

import 'dart:async';

import '../dart_downloader2.dart';
import '../easy_downloader_test.dart';
import '../extensions/int_extension.dart';
import '../model/download.dart';
import '../model/status.dart';

class DownloadMonitor {
  Download download;
  DownloadMonitor(this.download);

  void updateDownload(Download download) {
    this.download = download;
  }

  void monitor(Duration duration){
    Timer.periodic(duration, (timer) {
      print("monitoring ${download.parts.length} parts");
      for (var value in download.parts) {
        print("part ${value.id} start: ${value.start}, downloaded: ${value.downloaded.toHumanReadableSize()}, end: ${value.end}, status ${value.status}");
      }
      if (download.parts.isNotEmpty && download.parts.every((element) => element.status == PartFileStatus.completed)) {
        print("download completed total downloaded: ${download.parts.map((e) => e.end - e.start).reduce((value, element) => value + element).toHumanReadableSize()}");
        var lst = download.parts;
        lst.sort((a, b) => a.start.compareTo(b.start));
        for (var value in lst) {
          print("part ${value.id} start: ${value.start}, downloaded: ${value.downloaded.toHumanReadableSize()}, end: ${value.end}, status ${value.status}");
        }
        var url = "https://raw.githubusercontent.com/yourkin/fileupload-fastapi/a85a697cab2f887780b3278059a0dd52847d80f3/tests/data/test-10mb.bin";

        DartDownloader().download(url);

        timer.cancel();
      }}
    );
  }
}