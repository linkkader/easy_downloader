// Created by linkkader on 12/10/2022

import 'dart:isolate';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/model/download.dart';
import 'package:easy_downloader/storage/block.dart';
import 'package:hive/hive.dart';
import 'status.dart';

part 'easy_downloader.g.dart';


@HiveType(typeId: 101)
class DownloadTask{
  @HiveField(0)
  final int downloadId;
  @HiveField(1)
  final int totalLength;
  @HiveField(3)
  final String path;
  @HiveField(4)
  final int maxSplit;
  @HiveField(5)
  final DownloadStatus status;
  @HiveField(7)
  final int downloaded;
  @HiveField(6)
  final List<DownloadBlock> blocks;
  @HiveField(8)
  final String filename;
  @HiveField(9)
  final String tempPath;
  @HiveField(10)
  final Map<String, String> headers;
  @HiveField(11)
  final String url;
  const DownloadTask(
      this.url,
      this.downloadId, this.totalLength,
      this.path, this.maxSplit, this.status,
      this.blocks, this.downloaded,
      this.tempPath, this.filename, this.headers);

  DownloadTask copyWith({
    String? url,
    int? downloadId, int? totalLength, String? path,
    int? maxSplit, DownloadStatus? status, List<DownloadBlock>? blocks, int? downloaded,
    String? tempPath, String? filename, Map<String, String>? headers
  }){
    return DownloadTask(
      url ?? this.url,
      downloadId ?? this.downloadId,
      totalLength ?? this.totalLength,
      path ?? this.path,
      maxSplit ?? this.maxSplit,
      status ?? this.status,
      blocks ?? this.blocks,
      downloaded ?? this.downloaded,
      tempPath ?? this.tempPath,
      filename ?? this.filename,
      headers ?? this.headers
    );
  }
  
  Download toDownload(SendPort sendPort){
    return Download(
      tempPath: tempPath,
      headers: headers,
      filename: filename,
      maxSplit: maxSplit,
      path: path,
      sendPortMainThread: sendPort,
      totalLength: totalLength,
      downloadId: downloadId,
    );
  }

  Task toTask(){
    return Task(
      url,
      downloadId,
      totalLength,
      path,
      maxSplit,
      status,
      blocks,
      downloaded,
      tempPath,
      filename,
      headers
    );
  }
}