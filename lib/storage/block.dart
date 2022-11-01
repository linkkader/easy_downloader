import 'package:easy_downloader/storage/status.dart';
import 'package:hive/hive.dart';
import '../easy_downloader.dart';
import '../model/part_file.dart';

part 'block.g.dart';

@HiveType(typeId: 102)
class DownloadBlock {
  @HiveField(0)
  final int start;
  @HiveField(1)
  final int end;
  @HiveField(2)
  final int id;
  @HiveField(3)
  final PartFileStatus status;
  @HiveField(4)
  final int downloaded;
  const DownloadBlock(
      this.id, this.start, this.end, this.downloaded, this.status);

  ///convert to PartFile
  PartFile toPartFile(Download download) {
    var part = PartFile(
      id: id,
      start: start,
      end: end,
      download: download,
    );
    part.updateDownloaded(downloaded, fromMainThread: true);
    if (status != PartFileStatus.completed) {
      part.updateStatus(PartFileStatus.paused, fromMainThread: true);
    }
    return part;
  }
}
