// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import '../easy_downloader.dart';
import '../model/download.dart';
import '../model/download_info.dart';
import '../storage/status.dart';
import '../monitor/download_monitor.dart';
import '../monitor/monitor.dart';
import 'download_part.dart';


void isolateListen(
    ReceivePort receivePort,
    DownloadInfo info,
    DownloadMonitor? downloadMonitor,
    Download? download,
    Function(Download)? onDownloadUpdate) {
  DownloadMonitorInside? monitor;
  late StreamSubscription subscription;
  List<Isolate> children = [];

  if (download != null){
    monitor = DownloadMonitorInside(download, downloadMonitor: downloadMonitor);
    monitor.monitor();

  }
  subscription = receivePort.listen((message) async {
    if (message is SendPort) {
      message.send(info);
    }
    if (message is List) {
      if (message[0] == SendPortStatus.setDownload){
        log('download started', name: 'easy_downloader');
        download = message[1];
        await download!.save();
        onDownloadUpdate?.call(download!);
        var sendPort = message[2] as SendPort;
        sendPort.send(message[3]);
        monitor = DownloadMonitorInside(download!, downloadMonitor: downloadMonitor);
        monitor?.monitor();
      }
      switch(message[0])
      {
        case SendPortStatus.setPart: download!.setPart(message[1]);break;
        case SendPortStatus.updatePartEnd: {
          download!.updatePartEnd(message[1], message[2]);break;
        }
        case SendPortStatus.updateIsolate: {
          download!.updatePartIsolate(message[1], message[2]);
          break;
        }
        case SendPortStatus.updatePartDownloaded: {
          download!.updatePartDownloaded(message[1], message[2]);
          break;
        }
        case SendPortStatus.updatePartSendPort: {
          download!.updatePartSendPort(message[1], message[2]);
          break;
        }
        case SendPortStatus.updatePartStatus: download!.updatePartStatus(message[1], message[2]);break;
        case SendPortStatus.currentLength:{
          download!.currentLength(message[1]);
          break;
        }
        case SendPortStatus.downloadPartIsolate: {
          //download!.downloadPartIsolate(message[1], info);
          downloadPartIsolate(message[1], message[2], partFile: message[3]);
          break;
        }
        case SendPortStatus.childIsolate: {
          if (download == null){
            children.add(message[1]);
          }else{
            for(var isolate in children){
              download!.addChildren(isolate);
            }
            children.clear();
            download!.addChildren(message[1]);
          }
          break;
        }
        case SendPortStatus.stop: {
          log("stop isolate listen", name: "easy_downloader");
          monitor?.dispose();
          subscription.cancel();
          break;
        }
        case SendPortStatus.append: {
          await download?.append();
          log("append done file output ${download?.path}/${download?.filename}", name: "easy_downloader");
          download?.sendPortMainThread.send(SendPortStatus.stop);
          break;
        }
      }
    }
  });

}

