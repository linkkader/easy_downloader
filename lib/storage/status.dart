// Created by linkkader on 7/10/2022

import 'package:hive/hive.dart';

part 'status.g.dart';

@HiveType(typeId: 104)
enum DownloadStatus {
  @HiveField(0)
  downloading,
  @HiveField(1)
  paused,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed,
  @HiveField(4)
  appending
}

@HiveType(typeId: 103)
enum PartFileStatus {
  @HiveField(0)
  downloading,
  @HiveField(1)
  resumed,
  @HiveField(2)
  completed,
  @HiveField(3)
  failed,
  @HiveField(4)
  paused
}

@HiveType(typeId: 105)
enum SendPortStatus {
  @HiveField(0)
  setDownload,
  @HiveField(1)
  updateMainSendPort1,
  @HiveField(2)
  updatePartDownloaded,
  @HiveField(3)
  pausePart,
  @HiveField(4)
  updatePartStatus,
  @HiveField(5)
  updatePartEnd,
  @HiveField(6)
  setPart,
  @HiveField(7)
  currentLength,
  @HiveField(8)
  updateIsolate,
  @HiveField(9)
  updatePartSendPort,
  @HiveField(10)
  downloadPartIsolate,
  @HiveField(11)
  childIsolate,
  @HiveField(12)
  allowDownloadAnotherPart,
  stop, append
}