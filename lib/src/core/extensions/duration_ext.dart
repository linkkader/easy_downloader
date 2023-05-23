/// Extension on [Duration] to convert it to human readable string
/// example: 1:30:00
/// 1 hour 30 minutes 0 seconds
extension DurationExt on Duration {
  /// Convert [Duration] to human readable string
  String toHumanReadable() {
    final hours = inHours;
    final minutes = inMinutes - hours * 60;
    final seconds = inSeconds - hours * 3600 - minutes * 60;
    // ignore: lines_longer_than_80_chars
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
