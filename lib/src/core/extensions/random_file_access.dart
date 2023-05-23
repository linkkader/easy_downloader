import 'dart:io';

///RandomAccessFileExtension for help to copy [RandomAccessFile]
///[copy] create new [RandomAccessFile] from [path]
extension RandomAccessFileExtension on RandomAccessFile {
  /// create new [RandomAccessFile] from [path]
  RandomAccessFile copy() {
    var file = File(path);
    return file.openSync(mode: FileMode.append);
  }
}
