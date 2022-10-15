// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadBlockAdapter extends TypeAdapter<DownloadBlock> {
  @override
  final int typeId = 45328;

  @override
  DownloadBlock read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadBlock(
      fields[2] as int,
      fields[0] as int,
      fields[1] as int,
      fields[4] as int,
      fields[3] as PartFileStatus,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadBlock obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.downloaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadBlockAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
