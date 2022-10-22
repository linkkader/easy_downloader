// Created by linkkader on 19/10/2022

import 'dart:developer';
import 'dart:io';
import 'package:easy_downloader/extensions/int_extension.dart';
import 'package:easy_downloader/storage/easy_downloader.dart';

//append all block
Future<void> appendFile(DownloadTask task) async {
  var output = File("${task.path}/${task.filename}");
  var blocks = task.blocks;
  if (output.existsSync()) {
    output.deleteSync(recursive: true);
  }
  var i = 0;
  blocks.sort((a, b) => a.start.compareTo(b.start));
  for (var value in blocks) {
    i++;
    var input = File("${task.tempPath}/${value.id}");
    var bytes = input.readAsBytesSync();
    if (i == blocks.length){
      bytes = bytes.sublist(0, value.end - value.start);
    }
    else{
      bytes = bytes.sublist(0, value.end - value.start);
    }
    output.writeAsBytesSync(bytes, mode: FileMode.append);
  }

  log("done ${output.path} ${output.lengthSync().toHumanReadableSize()}", name: "easy_downloader");
  var temp = Directory(task.tempPath);
  temp.delete(recursive: true);
}