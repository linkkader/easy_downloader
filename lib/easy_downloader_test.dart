import 'dart:async';
import 'dart:io';

import 'package:easy_downloader/dart_downloader2.dart';
import 'package:easy_downloader/extensions/int_extension.dart';
import 'package:flutter_test/flutter_test.dart';



void main() {
  test('adds one to input values', () async {
    var completer = Completer();

    var file = File('test/test.mp4');
    Stopwatch stopwatch = Stopwatch()..start();
    //500KB
    var url = "https://www.learningcontainer.com/download/sample-mp4-video-file-download-for-testing/?wpdmdl=2727&refresh=62dca61b7ad061658627611";
    //100MB
    url = "https://speed.hetzner.de/100MB.bin";
    url = "https://raw.githubusercontent.com/yourkin/fileupload-fastapi/a85a697cab2f887780b3278059a0dd52847d80f3/tests/data/test-10mb.bin";

    DartDownloader().download(url);
    await completer.future;
  });
}
