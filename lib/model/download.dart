// Created by linkkader on 7/10/2022

import 'dart:isolate';
import 'package:easy_downloader/model/status.dart';
import 'part_file.dart';

class Download{
  late SendPort sendPortMainThread;
  final int totalLength;
  final String path;
  final int maxSplit;
  int _current = 0;
  final Map<int, PartFile> _parts = {};
  Download({required this.totalLength,required this.path, required this.maxSplit, required this.sendPortMainThread});

  int get current => _current;

  void incrementCurrent({bool fromMainThread = false, int? value}){
    if (value != null) {
      _current = value;
      return;
    }
    _current++;
    if (!fromMainThread) sendPortMainThread.send([SendPortStatus.incrementCurrent]);
    if (fromMainThread){
      print('increment current from main thread $_current');
      _parts.forEach((key, value) {
        value.sendPort?.send([SendPortStatus.incrementCurrent, _current]);
      });
    }
  }

  void setPart(PartFile part){
    assert(_parts[part.id] == null);
    _parts[part.id] = part;
  }

  void updatePartDownloaded(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateDownloaded(value, fromMainThread: true);
  }

  void updatePartEnd(int id, int value){
    assert(_parts[id] != null);
    _parts[id]!.updateEnd(value, fromMainThread: true);
  }

  void updatePartStatus(int id, PartFileStatus value){
    assert(_parts[id] != null);
    _parts[id]!.updateStatus(value, fromMainThread: true);
  }

  List<PartFile> get parts => _parts.values.toList();
}