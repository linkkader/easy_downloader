
import '../model/block.dart';
import '../model/status.dart';

typedef BlockMonitor = Function(List<DownloadBlock> blocks);
typedef ProgressMonitor = Function(int progress, int total, int speed, DownloadStatus status);

class DownloadMonitor {
  final BlockMonitor? blockMonitor;
  final Duration? duration;
  final ProgressMonitor? onProgress;
  const DownloadMonitor({this.blockMonitor, this.duration, this.onProgress});
}