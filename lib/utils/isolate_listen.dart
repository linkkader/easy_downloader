// Created by linkkader on 15/10/2022

import 'dart:async';
import 'dart:isolate';
import '../easy_downloader.dart';
import '../model/download.dart';
import '../model/download_info.dart';
import '../storage/status.dart';
import '../monitor/download_monitor.dart';
import '../monitor/monitor.dart';
import 'download_part.dart';


void isolateListen(ReceivePort receivePort, DownloadInfo info,
    Download? download,
    DownloadMonitor? downloadMonitor,
    Completer<int> completer,
    Function(Download)? onDownloadUpdate) {
  late DownloadMonitorInside monitor;
  late StreamSubscription subscription;
  List<Isolate> children = [];
  subscription = receivePort.listen((message) async {
    if (message is SendPort) {
      message.send(info);
    }
    if (message is List) {
      if (message[0] == SendPortStatus.setDownload){
        download = message[1];
        onDownloadUpdate?.call(download!);
        var id = await download!.save();
        completer.complete(id) ;
        var sendPort = message[2] as SendPort;
        print("sendPort now ${download!.downloadId}");
        sendPort.send(message[3]);
        monitor = DownloadMonitorInside(download!, downloadMonitor: downloadMonitor);
        monitor.monitor();
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
      //on resume need
        case SendPortStatus.updateMainSendPort: {
          download!.updateMainSendPort(message[1]);
          assert(message[2] is SendPort);
          var sendPort = message[2] as SendPort;
          sendPort.send(download);
          for (var part in download!.parts){
            part.retry(info);
          }
          break;
        }
        case SendPortStatus.downloadPartIsolate: {
          //download!.downloadPartIsolate(message[1], info);
          print(message);
          downloadPartIsolate(message[1], message[2], partFile: message[3]);
          break;
        }
        case SendPortStatus.childIsolate: {
          print("child Isolate $message");
          if (download == null){
            children.add(message[1]);
          }else{
            if (children.isNotEmpty){
              for (var child in children){
                download?.addChildren(child);
              }
              children.clear();
            }
            download?.addChildren(message[1]);
          }
          break;
        }
      }
    }
  });

}

