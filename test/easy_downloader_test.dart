import 'dart:async';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:flutter_test/flutter_test.dart';

var completer = Completer();

void main() {
  test('adds one to input values', () async {
    //500KB
    var url =
        "https://www.learningcontainer.com/download/sample-mp4-video-file-download-for-testing/?wpdmdl=2727&refresh=62dca61b7ad061658627611";
    //100MB
    url = "https://speed.hetzner.de/100MB.bin";
    url =
        "https://raw.githubusercontent.com/yourkin/fileupload-fastapi/a85a697cab2f887780b3278059a0dd52847d80f3/tests/data/test-10mb.bin";
    (url);
    EasyDownloader();
    //EasyDownloader().download(url);
    await completer.future;
  });
}
