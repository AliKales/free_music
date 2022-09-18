import 'package:hive_flutter/hive_flutter.dart';

part 'model_song.g.dart';

@HiveType(typeId: 1)
class ModelSong {
  @HiveField(0)
  String? songDownloadUrl;
  @HiveField(1)
  String? authorName;
  @HiveField(2)
  String? id;
  @HiveField(3)
  String? title;
  @HiveField(4)
  DateTime? downloadDate;
  @HiveField(5)
  String? thumbUrl;
  @HiveField(6)
  Duration? duration;
  @HiveField(7)
  String? lyrics;
  @HiveField(8)
  String? thumbnail;

  ModelSong({
    this.songDownloadUrl,
    this.authorName,
    this.id,
    this.title,
    this.downloadDate,
    this.thumbUrl,
    this.duration,
    this.lyrics,
    this.thumbnail,
  });

  ModelSong.fromJson(Map<String, dynamic> json) {
    songDownloadUrl = json['link'];
    authorName = json['author_name'];
    title = json['title'];
    downloadDate = DateTime.now();
    thumbUrl = json['thumbnail_url'];
    duration = calculateDuration(json['duration']);
    id = thumbUrl?.split("com/vi/").last.split("/hqdef").first;
  }

  Duration calculateDuration(double? val) {
    return Duration(seconds: val?.toInt() ?? 0);
  }
}
