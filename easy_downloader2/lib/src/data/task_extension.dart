

part of '../easy_downloader_base.dart';

extension TaskExtension on DownloadTask {
  void start(){
    EasyDownloader._downloadManager.downloadTask(this);
  }

  Future<void> pause() async {
    //ignore: lines_longer_than_80_chars
    final task = await EasyDownloader._localeStorage.getDownloadTask(downloadId);
    assert(task != null, 'EasyDownloader: task must not be null');
    await EasyDownloader._downloadManager.pauseTask(task!);
  }

  Future<void> continueDownload() async {
    //ignore: lines_longer_than_80_chars
    final task = await EasyDownloader._localeStorage.getDownloadTask(downloadId);
    assert(task != null, 'EasyDownloader: task must not be null');
    //ignore: lines_longer_than_80_chars
    assert(task!.status == DownloadStatus.paused, 'EasyDownloader: task status must be paused',);
    await EasyDownloader._downloadManager.continueTask(task!);
  }

  void cancel(){

  }

  DownloadTask updateSync(){
    final task = EasyDownloader._localeStorage.getDownloadTaskSync(downloadId);
    assert(task != null, 'EasyDownloader: task must not be null');
    return task!;
  }

  Future<DownloadTask> update() async {
    //ignore: lines_longer_than_80_chars
    final task = await EasyDownloader._localeStorage.getDownloadTask(downloadId);
    assert(task != null, 'EasyDownloader: task must not be null');
    return task!;
  }
}
