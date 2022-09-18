import 'package:audio_service/audio_service.dart';
import 'package:music_app/library/audio/audio_player_handler.dart';
import 'package:flutter/foundation.dart';

class Audio {
  AudioHandler? _audioHandler;
  bool isInited = false;
  final progressNotifier = ProgressNotifier();

  Future<AudioHandler?> init() async {
    _audioHandler = await AudioService.init(
      //IF THERE WILL BE AN ERROR PLEASE CHANGE IMPORT OF ABOVE COCE
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
    _listenToBufferedPosition();
    _listenToCurrentPosition();
    _listenToTotalDuration();
    return _audioHandler;
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler?.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler?.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void changeSong(MediaItem mediaItem) async {
    _audioHandler?.addQueueItem(mediaItem);
  }

  void setPlaylist(List<MediaItem> playlist) async {
    _audioHandler?.addQueueItems(playlist);
  }

  void play() => _audioHandler?.play();
  void pause() => _audioHandler?.pause();
  void stop() => _audioHandler?.stop();

  void seekToNext() => _audioHandler?.skipToNext();
  void seekToPrevious() => _audioHandler?.skipToPrevious();
}

class ProgressNotifier extends ValueNotifier<ProgressBarState> {
  ProgressNotifier() : super(_initialValue);
  static const _initialValue = ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}

class ProgressBarState {
  const ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}
