import 'package:hive_flutter/hive_flutter.dart';

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  void write(BinaryWriter writer, Duration value) =>
      writer.writeInt(value.inMicroseconds);

  @override
  Duration read(BinaryReader reader) =>
      Duration(microseconds: reader.readInt());

  @override
  // TODO: implement typeId
  int get typeId => 2;
}
