import 'dart:io';

extension RandomAccessFileExtension on RandomAccessFile {
  /// Copy the file to the given path
  RandomAccessFile copy() {
    var file = File(path);
    return file.openSync(mode: FileMode.append);
  }
}
