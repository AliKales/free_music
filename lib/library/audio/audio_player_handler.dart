import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/library/values.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();
  static List<MediaItem> listPlaylist = [];

  /// Initialise our audio handler.
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  // In this simple example, we handle only 4 actions: play, pause, seek and
  // stop. Any button press from the Flutter UI, notification, lock screen or
  // headset will be routed through to these 4 methods so that you can handle
  // your audio playback logic in one place.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> addQueueItem(MediaItem _mediaItem) async {
    mediaItem.add(_mediaItem);
    // Load the player.
    _player.setFilePath("$appDocPathToSongs/${_mediaItem.id}.mp3");
  }

  @override
  Future<void> addQueueItems(List<MediaItem> _mediaItems) async {
    MediaItem firstMediaItem = _mediaItems.first;
    _mediaItems.removeAt(0);

    // Define the playlist
    final playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: List.generate(
        _mediaItems.length,
        (index) => AudioSource.uri(
          Uri.parse("$appDocPathToSongs/${_mediaItems[index].id}.mp3"),
        ),
      ),
    );

    await _player.setAudioSource(playlist,
        initialIndex: int.parse(firstMediaItem.id));

    listPlaylist = _mediaItems;

    _player.currentIndexStream.listen((event) {
      if (event != null) mediaItem.add(listPlaylist[event]);
    });

    _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() async => await _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
