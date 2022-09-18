import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_app/library/audio/audio.dart';

class PAudio with ChangeNotifier {
  Audio audio = Audio();

  PlaybackState? playbackState;

  MediaItem? mediaItem;

  void setAudio(Audio a) {
    audio = a;
  }

  void setPlaybackState(PlaybackState p) {
    playbackState = p;
    notifyListeners();
  }

  void setMediaItem(MediaItem? m) {
    mediaItem = m;
    notifyListeners();
  }
}
