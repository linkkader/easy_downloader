// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/storage/easy_downloader.dart';
import '../model/part_file.dart';
import '../storage/status.dart';
import '../model/util_download.dart';
import 'current_length.dart';
import 'download_part.dart';

///save one block
Future<void> savePart(HttpClientResponse value, PartFile partFile,
    Download download, DownloadTask info,
    {PartFile? previousPart}) async {
  //need set this before add previous part
  if (partFile.id == -1) {
    Isolate.current.kill(priority: Isolate.immediate);
    return;
  }

  late StreamSubscription subscription;
  var receivePort = ReceivePort();
  //wait update from main thread
  subscription = receivePort.listen((message) async {
    if (message is List) {
      switch (message[0]) {
        case SendPortStatus.pausePart:
          {
            await value.detachSocket();
            if (partFile.status != PartFileStatus.completed) {
              partFile.updateStatus(PartFileStatus.paused);
            }
            Isolate.current.kill(priority: Isolate.immediate);
          }
      }
    }
    if (message is List && message[0] == SendPortStatus.updatePartEnd) {
      partFile.updateEnd(message[2], fromIsolate: true);
      downloadAnotherPart(download, partFile, info);
    }
    if (message is List &&
        message[0] == SendPortStatus.allowDownloadAnotherPart) {
      //partFile.updateEnd(message[2], fromIsolate: true);
      downloadAnotherPart(download, partFile, info);
    }
  });

  partFile.setSendPort(receivePort.sendPort);

  //download.sendPortMainThread.send([SendPortStatus.currentLength, receivePort.sendPort]);

  var file = File("${partFile.download.tempPath}/${partFile.id}");

  //check if max split is reached
  if (partFile.status != PartFileStatus.resumed) {
    while (await file.exists()) {
      var id = await currentLength(download);
      if (id == -1) {
        Isolate.current.kill(priority: Isolate.immediate);
        return;
      }
      partFile.updateId(id);
      file = File("${partFile.download.tempPath}/${partFile.id}");
    }
    file.createSync(recursive: true);
  }

  //need update
  partFile.setPartInDownload();
  partFile.updateStatus(PartFileStatus.downloading);
  int downloaded = 0;
  downloaded = file.lengthSync();

  if (file.existsSync()) {
    downloaded = file.lengthSync();
    partFile.updateDownloaded(downloaded);
  }
  int originalLength = partFile.end - partFile.start;
  value.listen((event) async {
    downloaded += event.length;
    file.writeAsBytesSync(event, mode: FileMode.append);
    partFile.updateDownloaded(downloaded);
    if (partFile.end != -1 && downloaded >= partFile.end - partFile.start) {
      partFile.updateStatus(PartFileStatus.completed);
      if (downloaded < originalLength) await value.detachSocket();
      subscription.cancel();
      Isolate.current.kill(priority: Isolate.immediate);
    }
  }).onError((_) {
    log("EasyDownloader: error in part ${partFile.id} $_");
    partFile.updateStatus(PartFileStatus.failed);
    Isolate.current.kill(priority: Isolate.immediate);
  });

  //update previous part end
  previousPart?.updateEnd(partFile.start);

  downloadAnotherPart(download, partFile, info);
  //try to download another part
  // Timer.periodic(const Duration(seconds: 1), (timer) {
  //   downloadAnotherPart(download, partFile, info);
  // });
}

///try to download another part
void downloadAnotherPart(
    Download download, PartFile partFile, DownloadTask info) async {
  int newStart = partFile.start +
      (partFile.end - partFile.start - partFile.downloaded) ~/ 2;
  if (partFile.end - newStart >= Download.minimumPartLength &&
      await currentLength(download) != -1) {
    var util = UtilDownload(newStart, partFile.end, download, partFile);
    downloadPart(util, info);
  }
}
