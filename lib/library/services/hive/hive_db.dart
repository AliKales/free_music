import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/library/models/model_playlist.dart';
import 'package:music_app/library/models/model_song.dart';
import 'package:music_app/library/services/hive/duration_adapter.dart';

class HiveDB {
  static Box<ModelSong>? songBox;
  static Box<ModelPlaylist>? playlistBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DurationAdapter());
    Hive.registerAdapter(ModelPlaylistAdapter());
    Hive.registerAdapter(ModelSongAdapter());
    songBox = await Hive.openBox<ModelSong>('songs');
    playlistBox = await Hive.openBox<ModelPlaylist>('playlists');
  }

  void addSong(ModelSong song) async {
    await songBox!.put(song.id, song);
  }

  ModelSong? getSongById(String id) {
    return songBox!.get(id);
  }

  void updateSongById(ModelSong song) {
    songBox!.put(song.id, song);
  }

  Future<void> addPlaylist(ModelPlaylist playlist) async {
    await playlistBox!.put(playlist.id, playlist);
  }

  Future<void> deletePlaylists(List<ModelPlaylist> playlists) async {
    for (var playlist in playlists) {
      await playlistBox!.delete(playlist.id);
    }
  }

  Future<void> addSongsToPlaylist(int playlistId, List<String> songIds) async {
    ModelPlaylist? playlist = playlistBox?.get(playlistId);

    if (playlist == null) return;

    List<String> idsFromPlaylist = playlist.songIds;

    idsFromPlaylist += songIds;

    playlist.songIds = idsFromPlaylist;

    await playlistBox?.put(playlistId, playlist);
  }

  Future<void> deleteSongsFromPlaylist(
      int playlistId, List<String> songIds) async {
    ModelPlaylist? playlist = playlistBox?.get(playlistId);

    if (playlist == null) return;

    for (var id in songIds) {
      playlist.songIds.removeWhere((element) => element == id);
    }

    await playlistBox?.put(playlistId, playlist);
  }

  bool checkPlaylistExisting(int value) =>
      playlistBox?.containsKey(value) ?? false;

  List<ModelSong>? getSongs() => songBox?.values.toList().reversed.toList();

  List<ModelPlaylist>? getPlaylists() =>
      playlistBox?.values.toList().reversed.toList();

  List<ModelSong>? getSongByIds(List<String> ids) => songBox?.values
      .toList()
      .where((element) => ids.contains(element.id))
      .toList();

  List<ModelSong> getUnAddedSongs(List<String> ids) =>
      songBox?.values
          .toList()
          .where((element) => !ids.contains(element.id))
          .toList() ??
      [];
}
