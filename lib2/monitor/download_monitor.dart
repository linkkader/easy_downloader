import '../storage/block.dart';
import '../storage/status.dart';

typedef BlockMonitor = Function(List<DownloadBlock> blocks);
typedef ProgressMonitor = Function(
    int downloaded, int total, int speed, DownloadStatus status);

/// A monitor for listen download task
class DownloadMonitor {
  final BlockMonitor? blockMonitor;
  final Duration? duration;
  final ProgressMonitor? onProgress;
  const DownloadMonitor({this.blockMonitor, this.duration, this.onProgress});
}
