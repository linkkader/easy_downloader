
import 'package:easy_downloader/model/status.dart';
import 'package:hive/hive.dart';

part 'block.g.dart';

@HiveType(typeId: 45328)
class DownloadBlock{
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
  const DownloadBlock(this.id, this.start, this.end, this.downloaded, this.status);
}