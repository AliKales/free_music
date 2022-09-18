import 'package:hive_flutter/hive_flutter.dart';

part 'model_playlist.g.dart';

@HiveType(typeId: 3)
class ModelPlaylist {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final DateTime createdDate;
  @HiveField(2)
  List<String> songIds;
  @HiveField(3)
  String title;

  ModelPlaylist({
    required this.id,
    required this.createdDate,
    required this.songIds,
    required this.title,
  });
}
