// Created by linkkader on 12/10/2022

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
  const DownloadTask(this.downloadId, this.totalLength, this.path, this.maxSplit, this.status, this.blocks, this.downloaded);

  DownloadTask copyWith({int? downloadId, int? totalLength, String? path, int? maxSplit, DownloadStatus? status, List<DownloadBlock>? blocks, int? downloaded}){
    return DownloadTask(
      downloadId ?? this.downloadId,
      totalLength ?? this.totalLength,
      path ?? this.path,
      maxSplit ?? this.maxSplit,
      status ?? this.status,
      blocks ?? this.blocks,
      downloaded ?? this.downloaded,
    );
  }
  
}