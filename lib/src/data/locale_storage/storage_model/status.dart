/// The status of a download
/// [downloading] downloading
/// [paused] paused
/// [completed] completed
/// [failed] failed
/// [appending] appending
/// [queuing] queuing
/// [none] none
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
/// [downloading] downloading
/// [finished] finished
/// [failed] failed
/// [none] none
enum BlockStatus {
  downloading,
  finished,
  failed,
}
