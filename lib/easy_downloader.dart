// Created by linkkader on 6/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'model/download.dart';
import 'model/part_file.dart';
import 'model/status.dart';
import 'monitor/download_monitor.dart';
import 'monitor/monitor.dart';

class DownloadController {

  Function? _pause;
  Function? _resume;

  void pause(){
    _pause?.call();
  }

  void resume(){
    _resume?.call();
  }

}

class EasyDownloader {
  late String url;
  DownloadMonitor? _downloadMonitor;
  static HttpClient _client = HttpClient();
  Download? _download;
  DownloadMonitorInside? _monitor;

  ReceivePort _downloadIsolate() {
    ReceivePort receivePort = ReceivePort();
    Isolate.spawn((message) {
      _DownloadInfo? downloadInfo;
      HttpClient? client;
      var sendPort = message;
      var receivePort = ReceivePort();
      message.send(receivePort.sendPort);
      late StreamSubscription subscription;
      subscription = receivePort.listen((message) {
        if (message is _DownloadInfo) {
          downloadInfo ??= message;
        }
        if (message is HttpClient) {
          client ??= message;
        }
        if (downloadInfo != null && client != null) {
          client!.getUrl(Uri.parse(downloadInfo!.url))
              .then((value) => value.close())
              .then((value) async {
                var download = Download(path: downloadInfo!.path, totalLength: value.contentLength, maxSplit: 1, sendPortMainThread: sendPort);
                sendPort.send([SendPortStatus.setDownload, download]);
                _savePart(value, PartFile(start: 0, end: download.totalLength, id: download.parts.length, download: download, isolate: Isolate.current), download, client!);
              });
          subscription.cancel();
        }
      });
    }, receivePort.sendPort);
    return receivePort;
  }

  ReceivePort _resumeIsolate() {
    ReceivePort receivePort = ReceivePort();
    Isolate.spawn((message) {
      _DownloadInfo? downloadInfo;
      UtilDownload? util;
      Download? download;
      var sendPort = message;
      var receivePort = ReceivePort();
      message.send(receivePort.sendPort);
      late StreamSubscription subscription;
      subscription = receivePort.listen((message) async {
        if (message is _DownloadInfo) {
          downloadInfo ??= message;
        }
        if (message is UtilDownload) {
          util ??= message;
        }
        if (message is Download) {
          download = message;
        }
        if (downloadInfo != null && util != null && download != null){
          var request = await util!.client.getUrl(Uri.parse(downloadInfo!.url));
          request.headers.add("Range", 'bytes=${util!.start}-${util!.end}');
          var partFile = PartFile(start: util!.end, end: util!.end, id: 0, download: download!, isolate: Isolate.current);
          request.close().then((value) {
            //_savePart(value, partFile, download!, util!.client);
          });
          // for (var part in _download!.parts.sublist(1)){
          //   _downloadPart(part.toUtilDownload(partFile, util!.client));
          // }
          subscription.cancel();

          // client.getUrl(Uri.parse(downloadInfo!.url))
          //     .then((value) => value.close())
          //     .then((value) async {
          //       var download = Download(path: downloadInfo!.path, totalLength: value.contentLength, maxSplit: 1, sendPortMainThread: sendPort);
          //       sendPort.send([SendPortStatus.setDownload, download]);
          //       _savePart(value, PartFile(start: 0, end: download.totalLength, id: download.parts.length, download: download, isolate: Isolate.current), download);
          //     });
          // subscription.cancel();
        }
      });
    }, receivePort.sendPort);
    return receivePort;
  }

  void _isolateListen(ReceivePort receivePort, _DownloadInfo info, DownloadController? downloadController) {
    downloadController?._pause = (){
      if (_download != null){
        for(var value in _download!.parts){
          if (value.status == PartFileStatus.downloading){
            value.sendPort?.send([SendPortStatus.pausePart]);
          }
        }
      }
    };

    downloadController?._resume = (){
      print("resume");
      if (_download != null){
        for(var value in _download!.parts){
          if (value.status == PartFileStatus.paused){
            //value.sendPort?.send([SendPortStatus.updatePartStatus, PartFileStatus.downloading]);;
            _isolateListen(_resumeIsolate(), info, downloadController);
          }
        }
      }
    };

    receivePort.listen((message) {
      if (message is SendPort) {
        message.send(info);
        message.send(EasyDownloader._client);
      }

      if (message is List)
      {
        if (message[0] == SendPortStatus.setDownload){
          assert(_download == null, "download is already set");
          _download = message[1];
          _monitor = DownloadMonitorInside(_download!, downloadMonitor: _downloadMonitor);
          _monitor?.monitor();
        }
        assert(_download != null, "download is null");
        switch(message[0])
        {
          case SendPortStatus.setPart: _download!.setPart(message[1]);break;
          case SendPortStatus.updatePartEnd: {
            _download!.updatePartEnd(message[1], message[2]);break;
          }
          case SendPortStatus.updatePartDownloaded: {
            _download!.updatePartDownloaded(message[1], message[2]);
            break;
          }
          case SendPortStatus.updatePartStatus: _download!.updatePartStatus(message[1], message[2]);break;
          case SendPortStatus.currentLength:{
            _download!.currentLength(message[1]);break;
          }
        }
      }
    });

  }

  void _resume(UtilDownload util) async {

  }

  Future<void> download(String url, String path, {DownloadMonitor? monitor, DownloadController? downloadController}) async {
    //clear all file in dir download
    var dir = Directory(path);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync();
    this.url = url;
    var receivePort = _downloadIsolate();
    _downloadMonitor = monitor;
    var info = _DownloadInfo(url, path);
    _isolateListen(receivePort, info, downloadController);
  }

  Future<void> _savePart(HttpClientResponse value, PartFile partFile, Download download, HttpClient client) async {
    late StreamSubscription subscription;
    var receivePort = ReceivePort();

    //wait update from main thread
    subscription = receivePort.listen((message) async {
      if (message is List){
        switch(message[0]){
          case SendPortStatus.pausePart : {
            await value.detachSocket();
            partFile.updateStatus(PartFileStatus.paused);
            Isolate.current.kill(priority: Isolate.immediate);
          }
        }
      }

      if (message is List && message[0] == SendPortStatus.updatePartEnd){
        partFile.updateEnd(message[2], fromIsolate: true);
        if (await _currentLength(download) < download.maxSplit)
        {
          int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
          _downloadPart(UtilDownload(newStart, partFile.end, download, partFile, client));
        }
      }

    });
    partFile.setSendPort(receivePort.sendPort);
    download.sendPortMainThread.send([SendPortStatus.currentLength, receivePort.sendPort]);

    //check if max split is reached
    if (await _currentLength(download) == download.maxSplit) {
      Isolate.current.kill(priority: Isolate.immediate);
      return;
    }


    var file = File("${partFile.download.path}/${partFile.id}");
    if (file.existsSync()){
      print("file ${partFile.id} exist");
    }
    //file.create();
    //need update
    partFile.setPartInDownload();
    partFile.updateStatus(PartFileStatus.downloading);
    int downloaded = 0;
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
    });
    if (await _currentLength(download) < download.maxSplit)
    {
      int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
      var util = UtilDownload(newStart, partFile.end, download, partFile, client);
      _downloadPart(util);
    }
  }

  void _downloadPart(UtilDownload util) async {
    ReceivePort port = ReceivePort();
    Isolate.spawn((message) async {
      ReceivePort receivePort = ReceivePort();
      message.send(receivePort.sendPort);
      receivePort.listen((message) async {
        if (message is UtilDownload){
          var util = message;
          var request = await message.client.getUrl(Uri.parse(url));
          request.headers.add("Range", 'bytes=${util.start}-${util.end}');
          var response = await request.close();
          if ((response.contentLength -  (util.end - util.start)).abs() < 3 && await _currentLength(util.download) < util.download.maxSplit)
          {
            util.previousPart.updateEnd(util.start);
            _savePart(response, PartFile(start: util.start, end: util.end, id: util.id ?? await _currentLength(util.download), download: util.download, isolate: Isolate.current), util.download, util.client);
          }
          else{
            Isolate.current.kill(priority: Isolate.immediate);
          }
        }
      });
    }, port.sendPort);

    port.listen((message) {
      if (message is SendPort){
        message.send(util);
      }
    });
  }

  //prevent file creation race condition
  Future<int> _currentLength(Download download) async {
    var receivePort = ReceivePort();
    var completer = Completer<int>();
    download.sendPortMainThread.send([SendPortStatus.currentLength, receivePort.sendPort]);
    receivePort.listen((message) {
      if (message is List && message[0] == SendPortStatus.currentLength){
        completer.complete(message[1]);
      }
    });
    return completer.future;
  }

}

class UtilDownload{
  final int start;
  final int end;
  final PartFile previousPart;
  final Download download;
  final int? id;
  final HttpClient client;
  const UtilDownload(this.start, this.end, this.download, this.previousPart, this.client, {this.id});
}

class _DownloadInfo {
  final String url;
  final String path;

  const _DownloadInfo(this.url, this.path);
}