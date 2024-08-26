// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DownloadClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadClassAdapter extends TypeAdapter<DownloadClass> {
  @override
  final int typeId = 1;

  @override
  DownloadClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadClass(
      videoID: fields[0] as String,
      title: fields[1] as String,
      progress: fields[2] as int,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadClass obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.videoID)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.progress)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
