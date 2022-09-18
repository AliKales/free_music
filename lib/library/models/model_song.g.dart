// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelSongAdapter extends TypeAdapter<ModelSong> {
  @override
  final int typeId = 1;

  @override
  ModelSong read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelSong(
      songDownloadUrl: fields[0] as String?,
      authorName: fields[1] as String?,
      id: fields[2] as String?,
      title: fields[3] as String?,
      downloadDate: fields[4] as DateTime?,
      thumbUrl: fields[5] as String?,
      duration: fields[6] as Duration?,
      lyrics: fields[7] as String?,
      thumbnail: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ModelSong obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.songDownloadUrl)
      ..writeByte(1)
      ..write(obj.authorName)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.downloadDate)
      ..writeByte(5)
      ..write(obj.thumbUrl)
      ..writeByte(6)
      ..write(obj.duration)
      ..writeByte(7)
      ..write(obj.lyrics)
      ..writeByte(8)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelSongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
