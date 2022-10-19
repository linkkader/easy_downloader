// Created by linkkader on 15/10/2022

import 'dart:io';
import 'dart:isolate';

import 'package:easy_downloader/utils/save_part.dart';

import '../model/download_info.dart';
import '../model/part_file.dart';
import '../storage/status.dart';
import '../model/util_download.dart';
import 'current_length.dart';

void downloadPart(UtilDownload util, DownloadInfo info, {PartFile? partFile}) async {
  if (util.previousPart.id == 1){
    util.download.sendPortMainThread.send([SendPortStatus.downloadPartIsolate, util, info, partFile]);
  }
  else {
    util.download.sendPortMainThread.send([SendPortStatus.downloadPartIsolate, util, info, partFile]);
  }
}

void downloadPartIsolate(UtilDownload util, DownloadInfo info, {PartFile? partFile}) async{
  ReceivePort port = ReceivePort();
  Isolate.spawn((message) async {
    ReceivePort receivePort = ReceivePort();
    DownloadInfo? info;
    PartFile? partFile;
    var client = HttpClient();
    UtilDownload? util;
    message.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message is UtilDownload){
        util ??= message;
      }
      if (message is DownloadInfo){
        info ??= message;
      }
      if (message is PartFile){
        partFile ??= message;
      }

      PartFile? previousPart;
      if (util != null && info != null){
        var file = File(info!.path);
        var length = 0;
        if (await file.exists()){
          length = await file.length();
        }
        var request = await client.getUrl(Uri.parse(info!.url));
        request.headers.add("Range", 'bytes=${util!.start + length}-${util!.end}');
        var response = await request.close();
        if ((response.contentLength -  (util!.end - util!.start)).abs() < 3
            && (partFile?.status == PartFileStatus.resumed
                || await currentLength(util!.download) != -1)
        )
        {
          //in resume previous is current
          if (partFile == null) {
            previousPart = util!.previousPart;
            //util!.previousPart.updateEnd(util!.start);
          }
          partFile ??= PartFile(start: util!.start, end: util!.end,
              id: util!.id ?? await currentLength(util!.download),
              download: util!.download, isolate: Isolate.current);
          savePart(response,
              partFile!,
              util!.download, info!, previousPart: previousPart);
        }
        else{
          Isolate.current.kill(priority: Isolate.immediate);
        }
      }
    });
  }, port.sendPort).then((value) {
    util.download.sendPortMainThread.send([SendPortStatus.childIsolate, value]);
  });
  port.listen((message) {
    if (message is SendPort){
      if (partFile != null) message.send(partFile);
      message.send(util);
      message.send(info.copyWith());
    }
  });
}