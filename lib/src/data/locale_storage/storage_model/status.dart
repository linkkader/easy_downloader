/// The status of a download
enum DownloadStatus {
  downloading,
  paused,
  completed,
  failed,
  appending,
  queuing,
  none,
}

/// The status of a block
enum BlockStatus {
  downloading,
  finished,
  failed,
}
