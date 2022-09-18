import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/components/auto_scroll_text.dart';
import 'package:music_app/library/components/progress_bar.dart';
import 'package:music_app/library/models/model_song.dart';
import 'package:music_app/library/services/hive/hive_db.dart';
import 'package:provider/provider.dart';

import '../../audio/audio.dart';
import '../../components/widget_lyrics/widget_lyrics.dart';
import '../../providers/p_audio.dart';

part 'mixin.dart';

class SongPageView extends StatefulWidget {
  const SongPageView({Key? key}) : super(key: key);

  @override
  State<SongPageView> createState() => _SongPageViewState();
}

class _SongPageViewState extends State<SongPageView> with _Mixin {
  bool _isGeniused = false;

  @override
  Widget build(BuildContext context) {
    bool isPlaying =
        Provider.of<PAudio>(context).playbackState?.playing ?? false;

    MediaItem? mediaItem = Provider.of<PAudio>(context).mediaItem;

    ModelSong? song = HiveDB().getSongById(mediaItem?.id ?? "");

    Audio audio = Provider.of<PAudio>(context).audio;

    _isGeniused = song?.thumbnail != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lyrics"),
      ),
      backgroundColor: !_isGeniused ? null : Colors.black,
      resizeToAvoidBottomInset: false,
      body: !_isGeniused
          ? _mainBody(song, mediaItem, audio, isPlaying)
          : NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: song?.thumbnail ?? "",
                          fit: BoxFit.fill,
                          height: context.dynamicHeight(0.8),
                          width: double.maxFinite,
                          errorWidget: (context, url, error) =>
                              const SizedBox.shrink(),
                        ),
                        Container(
                          height: context.dynamicHeight(0.8),
                          width: double.maxFinite,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Color.fromARGB(185, 0, 0, 0),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                        _mainBody(song, mediaItem, audio, isPlaying),
                      ],
                    ),
                    context.emptySizedHeightBoxLow3x,
                    WidgetLyrics(
                      song: song,
                      height: context.dynamicHeight(0.58),
                      isGeniused: _isGeniused,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _mainBody(
      ModelSong? song, MediaItem? mediaItem, Audio audio, bool isPlaying) {
    return Padding(
      padding: context.paddingNormal,
      child: SizedBox(
        height: _isGeniused ? context.dynamicHeight(0.75) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !_isGeniused
                ? WidgetLyrics(
                    song: song,
                    isGeniused: _isGeniused,
                  )
                : const Spacer(),
            context.emptySizedHeightBoxNormal,
            AutoScrollText(
              text: mediaItem?.title ?? "",
              textStyle: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isGeniused ? Colors.white : null),
            ),
            context.emptySizedHeightBoxLow,
            AutoScrollText(
              text: mediaItem?.artist ?? "",
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _isGeniused ? Colors.white : null),
            ),
            context.emptySizedHeightBoxNormal,
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: audio.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                    durationMax: value.total, durationCurrent: value.current);
              },
            ),
            context.emptySizedHeightBoxNormal,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconButtonSeekPrevious(audio),
                context.emptySizedWidthBoxLow3x,
                _iconButtonPlayPause(isPlaying, audio),
                context.emptySizedWidthBoxLow3x,
                _iconButtonSeekNext(audio),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconButton _iconButtonSeekPrevious(Audio audio) {
    return IconButton(
      onPressed: () {
        audio.seekToPrevious();
      },
      icon: Icon(
        Icons.skip_previous,
        color: _isGeniused ? Colors.white : null,
      ),
    );
  }

  Widget _iconButtonPlayPause(bool isPlaying, Audio audio) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        if (isPlaying) {
          audio.pause();
        } else {
          audio.play();
        }
      },
      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
    );
  }

  IconButton _iconButtonSeekNext(Audio audio) {
    return IconButton(
      onPressed: () {
        audio.seekToNext();
      },
      icon: Icon(
        Icons.skip_next,
        color: _isGeniused ? Colors.white : null,
      ),
    );
  }
}
