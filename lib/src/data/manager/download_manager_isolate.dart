// Created by linkkader on 17/2/2023

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:easy_downloader/src/core/extensions/int_extension.dart';
import 'package:easy_downloader/src/core/extensions/random_file_access.dart';
import 'package:easy_downloader/src/core/log/logger.dart';
import 'package:easy_downloader/src/core/utils/pair.dart';
import 'package:easy_downloader/src/core/utils/task_runner.dart';
import 'package:easy_downloader/src/core/utils/tupe.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/status.dart';

//isolate
class DownloadManagerIsolate{
  factory DownloadManagerIsolate() => _instance;
  DownloadManagerIsolate._internal();

  final Map<int, Completer<dynamic>> _mapCompleter = {};
  //ignore: lines_longer_than_80_chars
  final Map<int, List<Pair<HttpClient, TaskRunner<Tuple<List<int>, int, DownloadBlock>>>>> _taskClientMap = {};

  static Log log = Log();
  static bool _isInit = false;
  static late SendPort _sendPort;
  //ignore: lines_longer_than_80_chars
  static final DownloadManagerIsolate _instance = DownloadManagerIsolate._internal();

  static DownloadManagerIsolate init(SendPort sendPort) {
    assert(!_isInit, 'DownloadManager already initialized');
    _sendPort = sendPort;
    _isInit = true;
    return _instance;
  }

  Future<void> downloadTask(DownloadTask downloadTask) async {
    assert(_isInit, 'DownloadManager not initialized');
    final client = HttpClient();
    _taskClientMap[downloadTask.downloadId] = [];
    await client.getUrl(Uri.parse(downloadTask.url)).then((value) {
      downloadTask.headers.forEach((k, v) {
        value.headers.add(k, v);
      });
      return value.close();
    }).then((value) async {
      final block = DownloadBlock(
        currentSplit: 1,
        end: value.contentLength,
      );
      //ignore: lines_longer_than_80_chars
      var task = downloadTask.copyWith(totalLength: value.contentLength, blocks: [...downloadTask.blocks ,block], status: DownloadStatus.downloading);
      task = await _updateTask(task);
      final raf = await File(task.outputFilePath).open(mode: FileMode.append);
      await _generateFile(raf, value.contentLength);
      await _saveBlock(block, task, value, raf, client);
    });
  }

  Future<void> _tryDownloadAnotherBlock(DownloadBlock block, DownloadTask task,
      void Function(int) updateOldBlockEnd, RandomAccessFile randomAccessFile,)
  async {
    if (await _taskBlockLength(task) < task.maxSplit){
      await _downloadNextBlock(block, task,
        randomAccessFile,
        updateOldBlockEnd: updateOldBlockEnd,

      );
    }
  }

  Future<void> _downloadNextBlock(
      DownloadBlock oldBlock,
      DownloadTask task,
      RandomAccessFile randomAccessFile,
      {void Function(int end)? updateOldBlockEnd,}
      )
  async {
    assert(_isInit, 'DownloadManager not initialized');
    //ignore: lines_longer_than_80_chars
    assert(_taskClientMap[task.downloadId] != null, 'DownloadManager: _downloadNextBlock failed _taskClientMap is null');
    final client = HttpClient();
    //ignore: lines_longer_than_80_chars
    final newStart = oldBlock.start + (oldBlock.end - oldBlock.start - oldBlock.downloaded) ~/ 2;
    final newEnd = oldBlock.end;
    if (newStart - oldBlock.start < 1.megabytes()) {
      return;
    }
    await client.getUrl(Uri.parse(task.url)).then((value) {
      task.headers.forEach((k, v) {
        value.headers.add(k, v);
      });
      value.headers.add('Range', 'bytes=$newStart-$newEnd');
      return value.close();
    }).then((value) async {
      DownloadBlock? block = DownloadBlock(
        end: newEnd,
        id: -1,
        start: newStart,
      );
      block = await _updateTaskBlock(task, block);
      if (block != null){
        updateOldBlockEnd?.call(newStart);
        await _saveBlock(block, task, value, randomAccessFile, client);
      }
      else{
        client.close(force: true);
      }
    });
  }


  Future<void> _continueBlock(
      DownloadBlock downloadBlock,
      DownloadTask task,RandomAccessFile randomAccessFile,
      ) async{
    assert(_isInit, 'DownloadManager not initialized');
    //ignore: lines_longer_than_80_chars
    assert(_taskClientMap[task.downloadId] != null, 'DownloadManager: _downloadNextBlock failed _taskClientMap is null');
    final client = HttpClient();
    var block = downloadBlock.copyWith();
    final newStart = block.start + block.downloaded;
    final newEnd = block.end;
    await client.getUrl(Uri.parse(task.url)).then((value) {
      task.headers.forEach((k, v) {
        value.headers.add(k, v);
      });
      value.headers.add('Range', 'bytes=$newStart-$newEnd');
      return value.close();
    }).then((value) async {
      block = block.copyWith(status: BlockStatus.downloading);
      final newBlock = await _updateTaskBlock(task, block);
      if (newBlock != null){
        await _saveBlock(block, task, value, randomAccessFile, client);
      }
      else{
        client.close(force: true);
        Exception('DownloadManager: _continueBlock failed');
      }
    });
  }

  Future<void> continueTask(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    _taskClientMap[task.downloadId] = [];
    final raf = await File(task.outputFilePath).open(mode: FileMode.append);
    for(final block in task.blocks){
      await _continueBlock(block, task, raf);
    }

    _sendPort.send(Pair(SendPortStatus.continueTaskSuccess, task));
  }


  Future<void> _generateFile(RandomAccessFile randomAccessFile, int length)
  async {
    final buffer = List.generate(1.megabytes(), (index) => 0);
    final count = length ~/ buffer.length;
    final remain = length % buffer.length;
    for (var i = 0; i < count; i++) {
      await randomAccessFile.writeFrom(buffer);
    }
    if (remain > 0) {
      await randomAccessFile.writeFrom(buffer.sublist(0, remain));
    }
  }


  void continueCompleter(int hashCode, dynamic task){
    assert(_isInit, 'DownloadManager not initialized');
    _mapCompleter[hashCode]?.complete(task);
  }


  Future<DownloadTask> _updateTask(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    final completer = Completer<DownloadTask>();
    _mapCompleter[completer.hashCode] = completer;
    //ignore: lines_longer_than_80_chars
    _sendPort.send(Pair(SendPortStatus.updateTask, Pair(task, completer.hashCode,),),);
    final value = await completer.future;
    _mapCompleter.remove(completer.hashCode);
    return value;
  }

  Future<int> _taskBlockLength(DownloadTask task) async {
    assert(_isInit, 'DownloadManager not initialized');
    final completer = Completer<int>();
    _mapCompleter[completer.hashCode] = completer;
    //ignore: lines_longer_than_80_chars
    _sendPort.send(Pair(SendPortStatus.blockLength, Pair(task, completer.hashCode)));
    final value = await completer.future;
    _mapCompleter.remove(completer.hashCode);
    return value;
  }

  void _finishBlock(DownloadBlock block, DownloadTask task) {
    assert(_isInit, 'DownloadManager not initialized');
    _sendPort.send(Pair(SendPortStatus.blockFinished, Pair(task, block)));
  }

  //ignore: lines_longer_than_80_chars
  Future<DownloadBlock?> _updateTaskBlock(DownloadTask task, DownloadBlock block) async {
    assert(_isInit, 'DownloadManager not initialized');
    final completer = Completer<DownloadBlock?>();
    _mapCompleter[completer.hashCode] = completer;
    _sendPort.send(Pair(SendPortStatus.updateBlock,
        Tuple(task, block, completer.hashCode),),);
    final value = await completer.future;
    _mapCompleter.remove(completer.hashCode);
    return value;
  }

  Future<void> _saveBlock(
      DownloadBlock downloadBlock, DownloadTask task,
      HttpClientResponse response, RandomAccessFile randomAccessFile,
      HttpClient client,)
  async {
    var block = downloadBlock.copyWith();
    late TaskRunner<Tuple<List<int>, int, DownloadBlock>> runner;
    assert(_isInit, 'DownloadManager not initialized');
    var downloaded = block.downloaded;
    Future<void> finish(BlockStatus status) async {
      client.close(force: true);
      await runner.whenDone();
      block = block.copyWith(status: status);
      await _updateTaskBlock(task, block);
      _finishBlock(block, task);
      runner.clear();
    }
    runner = TaskRunner<Tuple<List<int>, int, DownloadBlock>>
      ((event, runner) async {
      final raf = randomAccessFile.copy();
      await raf.setPosition(block.start + event.second);
      await raf.writeFrom(event.first);
      await raf.close();
      //ignore: lines_longer_than_80_chars
      final newBlock = event.third.copyWith(downloaded: event.second + event.first.length);
      await _updateTaskBlock(task, newBlock);
    }, maxConcurrentTasks: 10000,);

    _taskClientMap[task.downloadId] ??= [];
    _taskClientMap[task.downloadId]!.add(Pair(client, runner));

    Future<void> updateOldBlockEnd(int end) async {
      block = block.copyWith(end: end);
      await _updateTaskBlock(task, block);
      await _tryDownloadAnotherBlock(
          block, task,
          updateOldBlockEnd, randomAccessFile,
      );
    }
    await _tryDownloadAnotherBlock(
        block, task,
        updateOldBlockEnd, randomAccessFile,
    );
    final chunkReader = ChunkedStreamIterator(response);
    while(true){
      var event = <int>[];
      try{
        event = await chunkReader.read(512.kilobytes());
      } catch(e){
        await finish(BlockStatus.failed);
        break;
      }
      if (event.isNotEmpty){
        runner.add(Tuple(event, downloaded, block));
      }
      if (event.length < 512.kilobytes()){
        await finish(BlockStatus.finished);
        break;
      }
      downloaded += event.length;
      block = block.copyWith(downloaded: downloaded);
      if (block.end > 0 &&  block.downloaded >= block.end - block.start){
        await finish(BlockStatus.finished);
        break;
      }
      // log.d('downloaded: ${block.currentSplit} ${block.downloaded.toHumanReadableSize()} / ${(block.end - block.start).toHumanReadableSize()} ${Duration(milliseconds: stopwatch.elapsedMilliseconds).inSeconds}}');
    }
    return;

    // subscription = response.listen((event){
    //   runner.add(Tuple(event, downloaded, block));
    //   downloaded += event.length;
    //   block = block.copyWith(downloaded: downloaded);
    //   if (block.end > 0 &&  block.downloaded >= block.end - block.start){
    //     finish();
    //   }
    //   print("downloaded: ${block.currentSplit} ${block.downloaded.toHumanReadableSize()} / ${(block.end - block.start).toHumanReadableSize()} ${Duration(milliseconds: stopwatch.elapsedMilliseconds).inSeconds}}");
    // });
    // subscription.onDone(() async {
    //   finish();
    // });
    // return;

  }


  Future<void> pauseTask(DownloadTask downloadTask) async {
    assert(_isInit, 'DownloadManager not initialized');
    //ignore: lines_longer_than_80_chars
    assert(_taskClientMap[downloadTask.downloadId] != null, 'DownloadManager: pauseTask failed _taskClientMap is null');

    var task = downloadTask.copyWith();
    for (final key in _taskClientMap.keys){
      final value = _taskClientMap[key]!;
      for (final pair in value){
        pair.first.close(force: true);
      }
      for (final pair in value){
        await pair.second.whenDone();
      }
    }
    _taskClientMap.remove(task.downloadId);
    task = task.copyWith(status: DownloadStatus.paused);
    _sendPort.send(Pair(SendPortStatus.pauseTaskSuccess, task));
  }
}
