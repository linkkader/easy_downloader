// Created by linkkader on 5/12/2022

import 'package:easy_downloader/src/core/extensions/int_extension.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/status.dart';
import 'package:isar/isar.dart';

import 'isar_map_entity.dart';
part 'download_task.g.dart';

typedef DownloadTaskListener = void Function(DownloadTask task);

@Collection()

///class to store download task
///[downloadId] download id
///[inQueue] in queue
///[totalLength] total length
///[totalDownloaded] total downloaded
///[path] path
///[maxSplit] max split
///[status] status
///[blocks] blocks
///[fileName] file name
///[headers] headers
///[url] url
///[outputFilePath] output file path
///[hashCode] hash code
class DownloadTask {
  const DownloadTask({
    required this.headers,
    required this.path,
    required this.fileName,
    required this.url,
    this.downloadId = Isar.autoIncrement,
    this.totalLength = 0,
    this.maxSplit = 0,
    this.status = DownloadStatus.none,
    this.blocks = const [],
    this.totalDownloaded = 0,
    this.inQueue = false,
  });
  final Id downloadId;
  final bool inQueue;
  final int totalLength;
  final int totalDownloaded;
  final String path;
  final int maxSplit;
  @enumerated
  final DownloadStatus status;
  final List<DownloadBlock> blocks;
  final String fileName;
  final IsarMapEntity headers;
  final String url;

  String get outputFilePath => path.isEmpty ? fileName : '$path/$fileName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTask &&
          runtimeType == other.runtimeType &&
          downloadId == other.downloadId &&
          totalLength == other.totalLength &&
          totalDownloaded == other.totalDownloaded &&
          path == other.path &&
          maxSplit == other.maxSplit &&
          status == other.status &&
          blocks == other.blocks &&
          fileName == other.fileName &&
          headers == other.headers &&
          url == other.url;
  @override
  int get hashCode {
    return downloadId.hashCode ^
        totalLength.hashCode ^
        totalDownloaded.hashCode ^
        path.hashCode ^
        maxSplit.hashCode ^
        status.hashCode ^
        blocks.hashCode ^
        fileName.hashCode ^
        headers.hashCode ^
        url.hashCode ^
        inQueue.hashCode;
  }

  @override
  String toString() {
    if (blocks.isNotEmpty) {
      blocks.sort((a, b) => a.start.compareTo(b.start));
    }
    //ignore: lines_longer_than_80_chars
    return 'DownloadTask{downloadId: $downloadId, totalLength: ${totalLength.toHumanReadableSize()}, totalDownloaded: ${totalDownloaded.toHumanReadableSize()}, path: $path, maxSplit: $maxSplit, status: $status, blocks: $blocks, filename: $fileName, headers: $headers, url: $url, inQueue: $inQueue}';
  }

  DownloadTask copyWith({
    int? downloadId,
    int? totalLength,
    int? totalDownloaded,
    String? path,
    int? maxSplit,
    DownloadStatus? status,
    List<DownloadBlock>? blocks,
    String? fileName,
    String? tempPath,
    IsarMapEntity? headers,
    String? url,
    bool? showNotification,
    bool? inQueue,
  }) {
    return DownloadTask(
      downloadId: downloadId ?? this.downloadId,
      totalLength: totalLength ?? this.totalLength,
      totalDownloaded: totalDownloaded ?? this.totalDownloaded,
      path: path ?? this.path,
      maxSplit: maxSplit ?? this.maxSplit,
      status: status ?? this.status,
      blocks: blocks ?? this.blocks,
      fileName: fileName ?? this.fileName,
      headers: headers ?? this.headers,
      url: url ?? this.url,
      inQueue: inQueue ?? this.inQueue,
    );
  }
}

@Embedded()

///class to store download block
///[start] start
///[end] end
///[id] id
///[downloaded] downloaded
///[status] status
///[currentSplit] current split
///[hashCode] hash code
///[copyWith] copy with
///[toString] to string
///[operator ==] operator ==
///[runtimeType] runtime type
class DownloadBlock {
  ///constructor
  const DownloadBlock({
    this.start = 0,
    this.end = 0,
    this.id = 0,
    this.downloaded = 0,
    this.status = BlockStatus.downloading,
    this.currentSplit = 0,
  });
  final int start;
  final int end;
  final int id;
  @enumerated
  final BlockStatus status;
  final int currentSplit;
  final int downloaded;

  ///copy with
  DownloadBlock copyWith(
      {int? start,
      int? end,
      int? id,
      int? downloaded,
      BlockStatus? status,
      int? currentSplit}) {
    return DownloadBlock(
      currentSplit: currentSplit ?? this.currentSplit,
      start: start ?? this.start,
      end: end ?? this.end,
      id: id ?? this.id,
      downloaded: downloaded ?? this.downloaded,
      status: status ?? this.status,
    );
  }

  ///equals
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DownloadBlock &&
        start == other.start &&
        end == other.end &&
        id == other.id &&
        downloaded == other.downloaded &&
        status == other.status &&
        currentSplit == other.currentSplit &&
        status == other.status;
  }

  ///to string
  @override
  String toString() =>
      'DownloadBlock(start: ${start.toHumanReadableSize()}, end: ${end.toHumanReadableSize()}, id: $id, downloaded: ${downloaded.toHumanReadableSize()}, status: $status, currentSplit: $currentSplit)';

  ///hashcode
  @override
  int get hashCode =>
      start.hashCode ^
      end.hashCode ^
      id.hashCode ^
      downloaded.hashCode ^
      status.hashCode ^
      currentSplit.hashCode;
}
