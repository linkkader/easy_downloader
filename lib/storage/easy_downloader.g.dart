// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'easy_downloader.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EasyDownloaderAdapter extends TypeAdapter<EasyDownloader> {
  @override
  final int typeId = 45327;

  @override
  EasyDownloader read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EasyDownloader(
      fields[0] as int,
      fields[1] as int,
      fields[3] as String,
      fields[4] as int,
      fields[5] as DownloadStatus,
      (fields[6] as List).cast<DownloadBlock>(),
    );
  }

  @override
  void write(BinaryWriter writer, EasyDownloader obj) {
    writer
      ..writeByte(6)
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
      ..writeByte(6)
      ..write(obj.blocks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EasyDownloaderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
