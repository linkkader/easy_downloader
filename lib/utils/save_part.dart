// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:developer';
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


//need set this before add previous part
Future<void> savePart(HttpClientResponse value, PartFile partFile, Download download, DownloadInfo info, {PartFile? previousPart}) async {

  //need set this before add previous part
  if (partFile.id == -1){
    Isolate.current.kill(priority: Isolate.immediate);
    return;
  }

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
      print("kader1");
      if (await currentLength(download) != -1)
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

    while (await file.exists()) {
      print("kader3");
      var id = await currentLength(download);
      if (id == -1) {
        Isolate.current.kill(priority: Isolate.immediate);
        return;
      }
      partFile.updateId(id);
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
    log("EasyDownloader: error in part ${partFile.id} $_");
    partFile.updateStatus(PartFileStatus.failed);
    Isolate.current.kill(priority: Isolate.immediate);
  });
  //util!.previousPart.updateEnd(util!.start);

  //update previous part end
  previousPart?.updateEnd(partFile.start);

  print("kader4");
  if (await currentLength(download) != -1)
  {
    int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
    var util = UtilDownload(newStart, partFile.end, download, partFile);
    downloadPart(util, info);
  }
}