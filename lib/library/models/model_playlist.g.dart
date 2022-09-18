// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelPlaylistAdapter extends TypeAdapter<ModelPlaylist> {
  @override
  final int typeId = 3;

  @override
  ModelPlaylist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelPlaylist(
      id: fields[0] as int,
      createdDate: fields[1] as DateTime,
      songIds: (fields[2] as List).cast<String>(),
      title: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ModelPlaylist obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdDate)
      ..writeByte(2)
      ..write(obj.songIds)
      ..writeByte(3)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelPlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
