

extension DurationExt on Duration {

  /// Convert [Duration] to human readable string
  String toHumanReadable() {
    final hours = inHours;
    final minutes = inMinutes - hours * 60;
    final seconds = inSeconds - hours * 3600 - minutes * 60;
    // ignore: lines_longer_than_80_chars
    final milliseconds = inMilliseconds - hours * 3600000 - minutes * 60000 - seconds * 1000;
    // ignore: lines_longer_than_80_chars
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}