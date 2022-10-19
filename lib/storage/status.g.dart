// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadStatusAdapter extends TypeAdapter<DownloadStatus> {
  @override
  final int typeId = 104;

  @override
  DownloadStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadStatus.downloading;
      case 1:
        return DownloadStatus.paused;
      case 2:
        return DownloadStatus.completed;
      case 3:
        return DownloadStatus.failed;
      default:
        return DownloadStatus.downloading;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadStatus obj) {
    switch (obj) {
      case DownloadStatus.downloading:
        writer.writeByte(0);
        break;
      case DownloadStatus.paused:
        writer.writeByte(1);
        break;
      case DownloadStatus.completed:
        writer.writeByte(2);
        break;
      case DownloadStatus.failed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartFileStatusAdapter extends TypeAdapter<PartFileStatus> {
  @override
  final int typeId = 103;

  @override
  PartFileStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartFileStatus.downloading;
      case 1:
        return PartFileStatus.resumed;
      case 2:
        return PartFileStatus.completed;
      case 3:
        return PartFileStatus.failed;
      case 4:
        return PartFileStatus.paused;
      default:
        return PartFileStatus.downloading;
    }
  }

  @override
  void write(BinaryWriter writer, PartFileStatus obj) {
    switch (obj) {
      case PartFileStatus.downloading:
        writer.writeByte(0);
        break;
      case PartFileStatus.resumed:
        writer.writeByte(1);
        break;
      case PartFileStatus.completed:
        writer.writeByte(2);
        break;
      case PartFileStatus.failed:
        writer.writeByte(3);
        break;
      case PartFileStatus.paused:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartFileStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SendPortStatusAdapter extends TypeAdapter<SendPortStatus> {
  @override
  final int typeId = 105;

  @override
  SendPortStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SendPortStatus.setDownload;
      case 1:
        return SendPortStatus.updateMainSendPort;
      case 2:
        return SendPortStatus.updatePartDownloaded;
      case 3:
        return SendPortStatus.pausePart;
      case 4:
        return SendPortStatus.updatePartStatus;
      case 5:
        return SendPortStatus.updatePartEnd;
      case 6:
        return SendPortStatus.setPart;
      case 7:
        return SendPortStatus.currentLength;
      case 8:
        return SendPortStatus.updateIsolate;
      case 9:
        return SendPortStatus.updatePartSendPort;
      case 10:
        return SendPortStatus.downloadPartIsolate;
      case 11:
        return SendPortStatus.childIsolate;
      case 12:
        return SendPortStatus.allowDownloadAnotherPart;
      default:
        return SendPortStatus.setDownload;
    }
  }

  @override
  void write(BinaryWriter writer, SendPortStatus obj) {
    switch (obj) {
      case SendPortStatus.setDownload:
        writer.writeByte(0);
        break;
      case SendPortStatus.updateMainSendPort:
        writer.writeByte(1);
        break;
      case SendPortStatus.updatePartDownloaded:
        writer.writeByte(2);
        break;
      case SendPortStatus.pausePart:
        writer.writeByte(3);
        break;
      case SendPortStatus.updatePartStatus:
        writer.writeByte(4);
        break;
      case SendPortStatus.updatePartEnd:
        writer.writeByte(5);
        break;
      case SendPortStatus.setPart:
        writer.writeByte(6);
        break;
      case SendPortStatus.currentLength:
        writer.writeByte(7);
        break;
      case SendPortStatus.updateIsolate:
        writer.writeByte(8);
        break;
      case SendPortStatus.updatePartSendPort:
        writer.writeByte(9);
        break;
      case SendPortStatus.downloadPartIsolate:
        writer.writeByte(10);
        break;
      case SendPortStatus.childIsolate:
        writer.writeByte(11);
        break;
      case SendPortStatus.allowDownloadAnotherPart:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendPortStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
