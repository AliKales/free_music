import 'package:flutter/material.dart';
import 'package:music_app/library/services/hive/hive_db.dart';

import '../models/model_playlist.dart';
import '../models/model_song.dart';

class PHomePage with ChangeNotifier {
  List<ModelSong> songs = [];
  List<ModelPlaylist> playlists = [];

  void setValuesFromHive() {
    songs = HiveDB().getSongs() ?? [];
    playlists = HiveDB().getPlaylists() ?? [];
    notifyListeners();
  }

  void addSong(ModelSong song) {
    songs.insert(0, song);
    notifyListeners();
  }

  void addPlaylist(ModelPlaylist playlist) {
    playlists.insert(0, playlist);
    notifyListeners();
  }
}
