// Created by linkkader on 6/10/2022

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'model/download.dart';
import 'model/part_file.dart';
import 'model/status.dart';
import 'monitor/monitor.dart';

typedef  UpdatePartEnd = Function(int newEnd);

class DartDownloader{
  late String url;
  final HttpClient client = HttpClient();
  Download? _download;
  DownloadMonitor? monitor;

  ReceivePort downloadIsolate() {
    ReceivePort receivePort = ReceivePort();


    Isolate.spawn((message) {
      HttpClient? client;
      String? url;

      var sendPort = message;
      var receivePort = ReceivePort();
      message.send(receivePort.sendPort);
      late StreamSubscription subscription;
      subscription = receivePort.listen((message) {
        if (message is HttpClient) {
          client = message;
        }
        if (message is String) {
          url = message;
        }
        if (client != null && url != null){
          client!.getUrl(Uri.parse(url!))
              .then((value) => value.close())
              .then((value) async {
                print("start download223  ${value.contentLength}");
                var download = Download(path: 'download/', totalLength: value.contentLength, maxSplit: 20, sendPortMainThread: sendPort);
                sendPort.send([SendPortStatus.setDownload, download]);
                _savePart(value, PartFile(start: 0, end: download.totalLength, id: download.parts.length, download: download, isolate: Isolate.current), download);
              });
          subscription.cancel();
        }
      });
    }, receivePort.sendPort);
    return receivePort;
  }

  void __savePart(ReceivePort receivePort) {
    receivePort.listen((message) {
      if (message is SendPort) {
        message.send(client);
        message.send(url);
      }

      if (message is List)
      {
        if (message[0] == SendPortStatus.setDownload){
          assert(_download == null, "download is already set");
          _download = message[1];
          monitor = DownloadMonitor(_download!);
          monitor?.monitor(const Duration(seconds: 5));
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
          case SendPortStatus.incrementCurrent: {
            _download!.incrementCurrent(fromMainThread: true);
            break;
          }

        }
      }
    });

  }


  Future<void> download(String url) async {

    //clear all file in dir download
    var dir = Directory('download/');
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
    dir.createSync();
    this.url = url;

    var receivePort = downloadIsolate();
    __savePart(receivePort);
  }

  Future<void> _savePart(HttpClientResponse value, PartFile partFile, Download download)
  async {
    late StreamSubscription subscription;
    var receivePort = ReceivePort();

    //check if max split is reached
    if (await currentLength(download) == download.maxSplit) {
      Isolate.current.kill(priority: Isolate.immediate);
      return;
    }

    //wait update from main thread
    subscription = receivePort.listen((message) async {
      if (message is List && message[0] == SendPortStatus.updatePartEnd){
        partFile.updateEnd(message[2], fromIsolate: true);
        if (await currentLength(download) < download.maxSplit)
        {
          int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
          _downloadPart(_Util(newStart, partFile.end, download, client, partFile));
        }
      }
      if (message is List && message[0] == SendPortStatus.incrementCurrent){
        print("current78 ${download.current}  &&  ${message[1]}");
        download.incrementCurrent(value : message[1]);
        //print("current78 ${download.current}  &&  ${message[1]}");
      }
    });
    partFile.setSendPort(receivePort.sendPort);
    partFile.setPartInDownload();
    partFile.updateStatus(PartFileStatus.downloading);
    int downloaded = 0;
    int originalLength = partFile.end - partFile.start;
    final file = File("download/${partFile.id}");
    if (!file.existsSync()) {
      file.createSync();
    }
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
    if (await currentLength(download) < download.maxSplit)
    {
      int newStart = partFile.start + (partFile.end - partFile.start) ~/ 2;
      var util = _Util(newStart, partFile.end, download, client, partFile);
      _downloadPart(util);
    }
  }

  void _downloadPart(_Util util) async {
    ReceivePort port = ReceivePort();

    Isolate.spawn((message) async {
      ReceivePort receivePort = ReceivePort();
      message.send(receivePort.sendPort);
      receivePort.listen((message) async {

        if (message is _Util){
          var util = message;
          var request = await util.client.getUrl(Uri.parse(url));
          request.headers.add("Range", 'bytes=${util.start}-${util.end}');
          var response = await request.close();
          if ((response.contentLength -  (util.end - util.start)).abs() < 3 && await currentLength(util.download) < util.download.maxSplit)
          {
            util.previousPart.updateEnd(util.start);
            _savePart(response, PartFile(start: util.start, end: util.end, id: await currentLength(util.download), download: util.download, isolate: Isolate.current), util.download);
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

  Future<int> currentLength(Download download) async {
    return download.current;
    var dir = Directory(download.path);
    return dir.list().length;
  }

  //truncate file
  void _truncateFile(File file, int length) {

  }

}

class _Util{
  final int start;
  final int end;
  final PartFile previousPart;
  final Download download;
  final HttpClient client;
  const _Util(this.start, this.end, this.download, this.client, this.previousPart);
}