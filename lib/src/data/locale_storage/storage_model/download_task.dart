// Created by linkkader on 5/12/2022


import 'package:easy_downloader/src/core/extensions/int_extension.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/status.dart';
import 'package:isar/isar.dart';
part 'download_task.g.dart';

@Collection()
class DownloadTask{
  const DownloadTask(
      {
        required this.path,
        required this.fileName,
        required this.url,
        this.downloadId = Isar.autoIncrement,
        this.totalLength = 0,
        this.maxSplit = 0,
        this.status = DownloadStatus.queuing,
        this.blocks = const [],
        this.totalDownloaded = 0,
        // this.headers = const IsarMapEntity(),
        this.showNotification = false,
      });
  final Id downloadId;
  final int totalLength;
  final int totalDownloaded;
  final String path;
  final int maxSplit;
  @enumerated
  final DownloadStatus status;
  final List<DownloadBlock> blocks;
  final String fileName;
  // final IsarMapEntity headers;
  final String url;
  final bool showNotification;


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
          // headers == other.headers &&
          url == other.url &&
          showNotification == other.showNotification;
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
      // headers.hashCode ^
      url.hashCode ^
      showNotification.hashCode;
  }

  @override
  String toString() {
    blocks.sort((a, b) => a.start.compareTo(b.start));
    //ignore: lines_longer_than_80_chars
    return 'DownloadTask{downloadId: $downloadId, totalLength: ${totalLength.toHumanReadableSize()}, totalDownloaded: ${totalDownloaded.toHumanReadableSize()}, path: $path, maxSplit: $maxSplit, status: $status, blocks: $blocks, filename: $fileName, headers: , url: $url, showNotification: $showNotification}';
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
    // IsarMapEntity? headers,
    String? url,
    bool? showNotification,
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
      // headers: headers ?? this.headers,
      url: url ?? this.url,
      showNotification: showNotification ?? this.showNotification,
    );
  }
}

@Embedded()
class DownloadBlock{
  const DownloadBlock(
      {
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

  //ignore: lines_longer_than_80_chars
  DownloadBlock copyWith({int? start, int? end, int? id, int? downloaded, BlockStatus? status, int? currentSplit}) {
    return DownloadBlock(
      currentSplit: currentSplit ?? this.currentSplit,
      start: start ?? this.start,
      end: end ?? this.end,
      id: id ?? this.id,
      downloaded: downloaded ?? this.downloaded,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other){
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

  @override
  String toString() => 'DownloadBlock(start: ${start.toHumanReadableSize()}, end: ${end.toHumanReadableSize()}, id: $id, downloaded: ${downloaded.toHumanReadableSize()}, status: $status, currentSplit: $currentSplit)';

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ id.hashCode ^ downloaded.hashCode ^ status.hashCode ^ currentSplit.hashCode;

}

enum SendPortStatus {
  updateMainIsolateSendPort,
  updateTask,
  completeUpdateTask,
  updateBlock,
  completeUpdateBlock,
  download,
  pauseTask,
  pauseTaskSuccess,
  blockLength,
  blockFinished,
  continueTask,
  continueTaskSuccess,
}

// @Embedded(inheritance: false)
// class IsarMapEntity<K, V> with MapMixin<K, V> {
//
//   @ignore
//   final Map<K, V> isarMap;
//
//   const IsarMapEntity({this.isarMap = const {}});
//
//   IsarMapEntity.empty() : isarMap = <K, V>{};
//   IsarMapEntity.fromMap(this.isarMap);
//
//   @override
//   V? operator [](Object? key) {
//     return isarMap[key];
//   }
//
//   @override
//   void operator []=(K key, V value) {
//     isarMap[key] = value;
//   }
//
//   @override
//   void clear() {
//     isarMap.clear();
//   }
//
//   @ignore
//   @override
//   Iterable<K> get keys => isarMap.keys;
//
//   @override
//   V? remove(Object? key) {
//     return isarMap.remove(key);
//   }
//
//   IsarMapEntity.fromJson(this.isarMap);
//   Map<K, V> toJson() => isarMap;
//
//   String get json => jsonEncode(map);
//   // set json(String value) => _map = jsonDecode(value);
//
// }


// @Embedded(inheritance: false)
// class IsarMapEntity2<K, V> with MapMixin<K, V> {
//   @ignore
//   Map<K, V> _map = {};
//
//   String get json => jsonEncode(_map);
//
//   set json(String value) => _map = jsonDecode(value);
//
//   @override
//   void operator []=(K key, value) => _map[key] = value;
//
//   @override
//   void clear() => _map.clear();
//
//   @ignore
//   @override
//   Iterable<K> get keys => _map.keys;
//
//   IsarMapEntity();
//
//   IsarMapEntity.fromJson(this._map);
//
//   Map<K, V> toJson() => _map;
//
//   @override
//   V? operator [](Object? key) {
//     return _map[key];
//   }
//
//   @override
//   V? remove(Object? key) {
//     return _map.remove(key);
//   }
//
//   IsarMapEntity<K, V> copyWith({Map<K, V>? map}) {
//     return IsarMapEntity<K, V>()
//       .._map = map ?? this._map;
//   }
//
//   static IsarMapEntity empty()  {
//     return const IsarMapEntity();
//   }
//
// }
