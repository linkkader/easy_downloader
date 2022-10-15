// Created by linkkader on 6/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:easy_downloader/extensions/int_extension.dart';

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
  static final HttpClient _client = HttpClient();
  Download? _download;
  DownloadMonitorInside? _monitor;

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
    // var receivePort = _resumeIsolate();
    _downloadMonitor = monitor;
    var info = _DownloadInfo(url, path, _client);

    _isolateListen(receivePort, info, downloadController, _download, monitor, (p0) => _download = p0,);

    downloadController?._pause = (){
      if (_download != null){
        for(var value in _download!.parts){
          if (value.status == PartFileStatus.downloading){
            value.sendPort?.send([SendPortStatus.pausePart]);
          }
        }
      }
      print("${_download?.parts.length}");
    };
    downloadController?._resume = () async{
      if (_download != null){
        receivePort.close();
        receivePort = _resumeIsolate();
        for(var value in _download!.parts){
          value.updateStatus(PartFileStatus.resumed, fromMainThread: true);
        }
        _isolateListen(receivePort, info, downloadController, _download, monitor, (p0) => _download = p0,);
        // if (value.status == PartFileStatus.paused){
        //   value.sendPort?.send([SendPortStatus.updatePartStatus, PartFileStatus.downloading]);;
        // }
      }
    };

    //_isolateListen(receivePort, info, downloadController, _download!, monitor!);

  }

}

ReceivePort _resumeIsolate() {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn((message) {
    _DownloadInfo? downloadInfo;
    HttpClient? client;
    Download? download;
    var sendPort = message;
    var receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    sendPort.send([SendPortStatus.updateMainSendPort, sendPort, receivePort.sendPort]);
    late StreamSubscription subscription;
    subscription = receivePort.listen((message) async {
      if (message is _DownloadInfo) {
        downloadInfo ??= message;
      }
      if (message is HttpClient) {
        client ??= message;
      }
      if (message is Download) {
        download ??= message;
      }
      if (downloadInfo != null && client != null && download != null) {
        //make an assert pause is possible only when minimum one part is downloading
        var util = download!.parts.first.toUtilDownload();
        var request = await client!.getUrl(Uri.parse(downloadInfo!.url));
        request.headers.add("Range", 'bytes=${util.start}-${util.end}');
        var partFile = download!.parts.first;
        request.close().then((value) {
          _savePart(value, partFile, download!, downloadInfo!);
        });

        subscription.cancel();
      }
    });
  }, receivePort.sendPort);
  return receivePort;
}

void _isolateListen(ReceivePort receivePort, _DownloadInfo info,
    DownloadController? downloadController, Download? download,
    DownloadMonitor? downloadMonitor, Function(Download)? onDownloadUpdate) {
  late DownloadMonitorInside monitor;
  late StreamSubscription subscription;
  subscription = receivePort.listen((message) {
    if (message is SendPort) {
      message.send(info);
      message.send(EasyDownloader._client);
    }
    if (message is List) {
      if (message[0] == SendPortStatus.setDownload){
        download = message[1];
        onDownloadUpdate?.call(download!);
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
          for (var part in download!.parts.sublist(1)){
            _downloadPart(part.toUtilDownload(), info, partFile: part);
          }
          break;
        }
      }
    }
  });

}

ReceivePort _downloadIsolate() {
  ReceivePort receivePort = ReceivePort();
  Isolate.spawn((message) {
    _DownloadInfo? downloadInfo;
    HttpClient client = HttpClient();
    var sendPort = message;
    var receivePort = ReceivePort();
    message.send(receivePort.sendPort);
    late StreamSubscription subscription;
    subscription = receivePort.listen((message) {
      if (message is _DownloadInfo) {
        downloadInfo ??= message;
      }
      if (downloadInfo != null) {
        client.getUrl(Uri.parse(downloadInfo!.url))
            .then((value) => value.close())
            .then((value) async {
          var download = Download(path: downloadInfo!.path, totalLength: value.contentLength, maxSplit: 8, sendPortMainThread: sendPort);
          sendPort.send([SendPortStatus.setDownload, download]);
          var partFile = PartFile(start: 0, end: download.totalLength, id: download.parts.length, download: download, isolate: Isolate.current);
          _savePart(value, partFile, download, downloadInfo!);
        });
        subscription.cancel();
      }
    });
  }, receivePort.sendPort);
  return receivePort;
}

void _downloadPart(UtilDownload util, _DownloadInfo info, {PartFile? partFile}) async {
  ReceivePort port = ReceivePort();
  Isolate.spawn((message) async {
    ReceivePort receivePort = ReceivePort();
    _DownloadInfo? info;
    PartFile? partFile;

    UtilDownload? util;
    message.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message is UtilDownload){
        util ??= message;
      }
      if (message is _DownloadInfo){
        info ??= message;
      }
      if (message is PartFile){
        partFile ??= message;
      }

      if (util != null && info != null){
        var request = await message.client.getUrl(Uri.parse(info!.url));
        request.headers.add("Range", 'bytes=${util!.start}-${util!.end}');
        var response = await request.close();
        if ((response.contentLength -  (util!.end - util!.start)).abs() < 3
            && (partFile?.status == PartFileStatus.resumed
                || await _currentLength(util!.download) < util!.download.maxSplit)
        )
        {
          //in resume previous is current
          if (partFile == null) util!.previousPart.updateEnd(util!.start);
          partFile ??= PartFile(start: util!.start, end: util!.end,
              id: util!.id ?? await _currentLength(util!.download),
              download: util!.download, isolate: Isolate.current);
          _savePart(response,
              partFile!,
              util!.download, info!);
        }
        else{
          Isolate.current.kill(priority: Isolate.immediate);
        }
      }
    });
  }, port.sendPort);

  port.listen((message) {
    if (message is SendPort){
      if (partFile != null) message.send(partFile);
      message.send(util);
      message.send(info.copyWith(client: HttpClient()));
    }
  });
}


Future<void> _savePart(HttpClientResponse value, PartFile partFile, Download download, _DownloadInfo info) async {
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
        _downloadPart(UtilDownload(newStart, partFile.end, download, partFile), info);
      }
    }
  });

  partFile.setSendPort(receivePort.sendPort);

  //download.sendPortMainThread.send([SendPortStatus.currentLength, receivePort.sendPort]);


  var file = File("${partFile.download.path}/${partFile.id}");

  //check if max split is reached
  if (partFile.status != PartFileStatus.resumed){
    if (await _currentLength(download) == download.maxSplit) {
      Isolate.current.kill(priority: Isolate.immediate);
      return;
    }

    while (await file.exists()) {
      partFile.updateId(await _currentLength(download));
      file = File("${partFile.download.path}/${partFile.id}");
    }
    file.createSync();
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
    if (partFile.end != -1 && downloaded >= partFile.end - partFile.start)
    {
      partFile.updateStatus(PartFileStatus.completed);
      if(downloaded < originalLength) await value.detachSocket();
      subscription.cancel();
      print("downloadPartCancel ${partFile.id} ${partFile.downloaded.toHumanReadableSize()} ${partFile.start.toHumanReadableSize()} ${partFile.end.toHumanReadableSize()}");
      Isolate.current.kill(priority: Isolate.immediate);
    }
  });
  if (await _currentLength(download) < download.maxSplit)
  {
    int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
    var util = UtilDownload(newStart, partFile.end, download, partFile);
    _downloadPart(util, info);
  }

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

class UtilDownload{
  final int start;
  final int end;
  final PartFile previousPart;
  final Download download;
  final int? id;
  const UtilDownload(this.start, this.end, this.download, this.previousPart, {this.id});
}

class _DownloadInfo {
  final String url;
  final String path;
  final HttpClient client;
  const _DownloadInfo(this.url, this.path, this.client);

  //copy
  _DownloadInfo copyWith({String? url, String? path, HttpClient? client}) => _DownloadInfo(
    url ?? this.url,
    path ?? this.path,
    client ?? this.client,
  );
}