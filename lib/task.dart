// Created by linkkader on 21/10/2022

part of 'easy_downloader.dart';

class Task extends DownloadTask{
  Task(super.url, super.downloadId, super.totalLength, super.path, super.maxSplit, super.status, super.blocks, super.downloaded, super.tempPath, super.filename, super.headers);

  void start({DownloadMonitor? monitor, DownloadController? controller}){
    var downloadController = DownloadController();
    var receivePort = downloadIsolate();
    var download = toDownload(receivePort.sendPort);
    isolateListen2(receivePort, this, monitor, download, (p0) {
      download = p0;
      EasyDownloader._controllers[download.downloadId] = downloadController;
      if (controller != null) {
        controller._pause = downloadController._pause;
        controller._resume = downloadController._resume;
      }
      //completer.complete(download.downloadId);
    });
    downloadController._pause = (){
      print("pause");
      downloadController.pause();
    };
    downloadController._resume = () async{
      assert(download.downloadId != -1);
      receivePort.close();
      download.updateStatus(DownloadStatus.downloading);
      print("resume ${download.parts.length}");
      for(var value in download.parts){
        if (value.mustRetry())value.updateStatus(PartFileStatus.resumed, fromMainThread: true);
      }
      //receivePort = resumeIsolate();
      receivePort = ReceivePort();
      //receivePort.sendPort.send(receivePort.sendPort);

      download.updateMainSendPort(receivePort.sendPort);
      isolateListen2(receivePort, this, monitor, download, (p0) => download = p0,);
      for (var part in download.parts){
        part.retry(this);
      }
      //receivePort.sendPort.send([SendPortStatus.updateMainSendPort, receivePort.sendPort, download]);
    };
  }
}

void isolateListen2(
    ReceivePort receivePort,
    Task info,
    DownloadMonitor? downloadMonitor,
    Download download,
    Function(Download)? onDownloadUpdate) {
  log("isolateListen2");
  late DownloadMonitorInside monitor;
  late StreamSubscription subscription;
  List<Isolate> children = [];
   
  monitor = DownloadMonitorInside(download, downloadMonitor: downloadMonitor);
  monitor.monitor();
  
  subscription = receivePort.listen((message) async {
    if (message is SendPort) {
      message.send(info);
    }
    if (message is List) {
      if (message[0] == SendPortStatus.setDownload){
        log('download started', name: 'easy_downloader');
        download = message[1];
        await download.save();
        monitor.updateDownload(download);
        onDownloadUpdate?.call(download);
        var sendPort = message[2] as SendPort;
        sendPort.send(message[3]);
      }
      switch(message[0])
      {
        case SendPortStatus.setPart: download.setPart(message[1]);break;
        case SendPortStatus.updatePartEnd: {
          download.updatePartEnd(message[1], message[2]);break;
        }
        case SendPortStatus.updateIsolate: {
          download.updatePartIsolate(message[1], message[2]);
          break;
        }
        case SendPortStatus.updatePartDownloaded: {
          download.updatePartDownloaded(message[1], message[2]);
          break;
        }
        case SendPortStatus.updatePartSendPort: {
          download.updatePartSendPort(message[1], message[2]);
          break;
        }
        case SendPortStatus.updatePartStatus: download.updatePartStatus(message[1], message[2]);break;
        case SendPortStatus.currentLength:{
          download.currentLength(message[1]);
          break;
        }
        case SendPortStatus.downloadPartIsolate: {
          //download.downloadPartIsolate(message[1], info);
          downloadPartIsolate(message[1], message[2], partFile: message[3]);
          break;
        }
        case SendPortStatus.childIsolate: {
          if (download == null){
            children.add(message[1]);
          }else{
            for(var isolate in children){
              download.addChildren(isolate);
            }
            children.clear();
            download.addChildren(message[1]);
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
          await download.append();
          log("append done file output ${download.path}/${download?.filename}", name: "easy_downloader");
          download.sendPortMainThread.send(SendPortStatus.stop);
          break;
        }
      }
    }
  });

}