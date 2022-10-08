
import 'package:easy_downloader/model/status.dart';

class DownloadBlock{
  final int start;
  final int end;
  final int id;
  final PartFileStatus status;
  final int downloaded;
  const DownloadBlock(this.id, this.start, this.end, this.downloaded, this.status);
}