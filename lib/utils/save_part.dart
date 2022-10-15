// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/extensions/int_extension.dart';

import '../model/download.dart';
import '../model/download_info.dart';
import '../model/part_file.dart';
import '../model/status.dart';
import '../model/util_download.dart';
import 'current_length.dart';
import 'download_part.dart';

Future<void> savePart(HttpClientResponse value, PartFile partFile, Download download, DownloadInfo info) async {
  print("download78 part ${partFile.start.toHumanReadableSize()} - ${partFile.end.toHumanReadableSize()}  ${partFile.status}");
  print("download781 ");

  late StreamSubscription subscription;
  var receivePort = ReceivePort();
  //wait update from main thread
  subscription = receivePort.listen((message) async {
    if (message is List){
      switch(message[0]){
        case SendPortStatus.pausePart : {
          await value.detachSocket();
          if (partFile.status != PartFileStatus.completed)partFile.updateStatus(PartFileStatus.paused);
          Isolate.current.kill(priority: Isolate.immediate);
        }
      }
    }
    if (message is List && message[0] == SendPortStatus.updatePartEnd){
      partFile.updateEnd(message[2], fromIsolate: true);
      if (await currentLength(download) < download.maxSplit)
      {
        int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
        downloadPart(UtilDownload(newStart, partFile.end, download, partFile), info);
      }
    }
  });

  print("download782 ");


  partFile.setSendPort(receivePort.sendPort);

  //download.sendPortMainThread.send([SendPortStatus.currentLength, receivePort.sendPort]);


  var file = File("${partFile.download.path}/${partFile.id}");

  print("download783 ");

  //check if max split is reached
  if (partFile.status != PartFileStatus.resumed){
    print("download783 length ${await currentLength(download)}");
    if (await currentLength(download) == download.maxSplit) {
      print("download783 kill isolate length ${await currentLength(download)}");

      Isolate.current.kill(priority: Isolate.immediate);
      return;
    }

    while (await file.exists()) {
      partFile.updateId(await currentLength(download));
      file = File("${partFile.download.path}/${partFile.id}");
    }
    file.createSync();
  }

  print("download784 ");

  //need update
  partFile.setPartInDownload();
  partFile.updateStatus(PartFileStatus.downloading);
  int downloaded = 0;
  downloaded = file.lengthSync();

  print("download785 ");

  if (file.existsSync()) {
    downloaded = file.lengthSync();
    partFile.updateDownloaded(downloaded);
  }
  int originalLength = partFile.end - partFile.start;
  value.listen((event) async {
    downloaded += event.length;
    file.writeAsBytesSync(event, mode: FileMode.append);
    partFile.updateDownloaded(downloaded);
    if (partFile.end != -1 && downloaded >= partFile.end - partFile.start)
    {
      partFile.updateStatus(PartFileStatus.completed);
      if(downloaded < originalLength) await value.detachSocket();
      subscription.cancel();
      Isolate.current.kill(priority: Isolate.immediate);
    }
  }).onError((_){
    partFile.updateStatus(PartFileStatus.failed);
    Isolate.current.kill(priority: Isolate.immediate);
  });

  print("download786 ");

  if (await currentLength(download) < download.maxSplit)
  {
    int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
    var util = UtilDownload(newStart, partFile.end, download, partFile);
    downloadPart(util, info);
  }

}