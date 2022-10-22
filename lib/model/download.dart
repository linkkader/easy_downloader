// Created by linkkader on 7/10/2022

part of '../easy_downloader.dart';

class Download{

  final Map<String, String> headers;
  final String tempPath;
  final String filename;
  String url;
  //minimum length for part is 2MB
  static const int minimumPartLength = 2 * 1048576;
  int _downloadId = -1;
  late SendPort sendPortMainThread;
  final int totalLength;
  final String path;
  final int maxSplit;
  final List<Isolate> allIsolate = [];
  DownloadStatus _status = DownloadStatus.downloading;
  final Map<int, PartFile> _parts = {};

  Timer? currentLengthTimer;
  List<SendPort> currentLengthSendPorts = [];

  Download({
    required this.url,
    required this.totalLength,
    required this.path,
    required this.maxSplit,
    required this.sendPortMainThread,
    required this.headers,
    required this.tempPath,
    required this.filename,
    required int downloadId,
  }){
    _downloadId = downloadId;
  }

  void setPart(PartFile part){
    if (part.status != PartFileStatus.resumed){
      assert(_parts[part.id] == null);
    }
    if (status != DownloadStatus.downloading){
      part.isolate?.kill(priority: Isolate.immediate);
      return;
    }
    _parts[part.id] = part;
    update();
  }

  void updatePartDownloaded(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateDownloaded(value, fromMainThread: true);
    update();
  }

  void updatePartEnd(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateEnd(value, fromMainThread: true);
    update();
  }

  void updatePartIsolate(int id, Isolate value){
    assert(_parts[id] != null);
    _parts[id]!.updateIsolate(value, fromMainThread: true);
    update();
  }

  void updatePartSendPort(int id, SendPort value){
    assert(_parts[id] != null);
    _parts[id]!.updateSendPort(value, fromMainThread: true);
    update();
  }

  // never call in child isolate
  void updateMainSendPort(SendPort sendPort){
    sendPortMainThread = sendPort;
    for(var part in _parts.values){
       part.download = this;
    }
    update();
  }

  void updatePartStatus(int id, PartFileStatus value){
    assert(_parts[id] != null);
    _parts[id]!.updateStatus(value, fromMainThread: true);
    var ss = parts;

    //finish downloading
    if (ss.isNotEmpty && ss.every((element) => element.status == PartFileStatus.completed)) {
      updateStatus(DownloadStatus.appending);
      sendPortMainThread.send([SendPortStatus.append]);
    }
    update();
  }

  //prevent data race for file creation
  //need dispose
  void currentLength(SendPort sendPort) {
    currentLengthSendPorts.add(sendPort);
    currentLengthTimer ??= Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (currentLengthSendPorts.isNotEmpty) {
        var sendPort = currentLengthSendPorts.removeAt(0);
        var length =  _parts.length;
        var downloading = _parts.length;
        if (downloading >= maxSplit) {
          length = -1;
        }
        if (status != DownloadStatus.downloading) {
          length = -1;
        }
        sendPort.send([SendPortStatus.currentLength, length]);
      }
    });
   }


  List<PartFile> get parts => _parts.values.toList();

  void updateStatus(DownloadStatus status) {
    _status = status;
    var controller = EasyDownloader.getController(_downloadId, ignoreNull: true);
    if (controller != null) {
      for (var element in controller._statusListeners) {
        element(status);
      }
    }
    update();
  }

  DownloadStatus get status => _status;

  void pause(){
    for(var value in parts){
      if (value.status == PartFileStatus.downloading){
        value.sendPort?.send([SendPortStatus.pausePart]);
      }
      updateStatus(DownloadStatus.paused);
    }
    ()async{
      //need wait isolate kill and update status
      await Future.delayed(const Duration(milliseconds: 50));
      sendPortMainThread.send([SendPortStatus.stop]);
    }();
  }

  void addChildren(Isolate isolate) {
    allIsolate.add(isolate);
  }

  Future<void> save() async {
    await StorageManager().add(_toDownloadTask());
  }

  DownloadTask _toDownloadTask() {
    var downloaded = 0;
    for(var part in parts){
      downloaded += part.downloaded;
    }
    var task = StorageManager.getTask(_downloadId);

    return DownloadTask(
      url,
      _downloadId,
      totalLength,
      path,
      maxSplit,
      status,
      parts.map((e) => e.toDownloadBlock()).toList(),
      downloaded,
      tempPath,
      filename,
      headers,
      isInQueue: task?.isInQueue ?? false,
      showNotification: task?.showNotification ?? false,
    );
  }

  void update() {
    assert(-1 != _downloadId);
    StorageManager().update(_downloadId, _toDownloadTask());
    var task = StorageManager.getTask(_downloadId);
    if (task != null && task.showNotification == true) {
      EasyDownloadNotification.showNotification(task);
    }
  }

  int get downloadId => _downloadId;

  Future<void> append() async {
    assert(status == DownloadStatus.appending);
    await appendFile(_toDownloadTask());
    updateStatus(DownloadStatus.completed);
  }

  DownloadTask toTask(){
    var downloaded = 0;
    var parts = _parts.values.map((e) => e.toDownloadBlock()).toList();
    for(var part in parts){
      downloaded += part.downloaded;
    }
    var task = EasyDownloader.getTask(_downloadId);
    task ??= DownloadTask(
        url,
        downloadId,
        totalLength,
        path,
        maxSplit,
        status,
        parts,
        downloaded,
        tempPath,
        filename,
        headers
    );
    return task;
  }
}