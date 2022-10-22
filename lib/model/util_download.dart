
import 'package:easy_downloader/model/part_file.dart';

import '../easy_downloader.dart';

class UtilDownload{
  final int start;
  final int end;
  final PartFile previousPart;
  final Download download;
  final int? id;
  const UtilDownload(this.start, this.end, this.download, this.previousPart, {this.id});
}