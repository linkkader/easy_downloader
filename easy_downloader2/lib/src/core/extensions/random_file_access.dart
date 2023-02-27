

import 'dart:io';

extension RandomAccessFileExtension on RandomAccessFile {

  RandomAccessFile copy() {
    var file = File(path);
    return file.openSync(mode: FileMode.append);
  }
}