// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'easy_downloader.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTaskAdapter extends TypeAdapter<DownloadTask> {
  @override
  final int typeId = 101;

  @override
  DownloadTask read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTask(
      fields[0] as int,
      fields[1] as int,
      fields[3] as String,
      fields[4] as int,
      fields[5] as DownloadStatus,
      (fields[6] as List).cast<DownloadBlock>(),
      fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadTask obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.downloadId)
      ..writeByte(1)
      ..write(obj.totalLength)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.maxSplit)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.downloaded)
      ..writeByte(6)
      ..write(obj.blocks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
