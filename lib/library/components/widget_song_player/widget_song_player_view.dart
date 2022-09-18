import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/pages/song_page/song_page_view.dart';
import 'package:provider/provider.dart';

import '../../audio/audio.dart';
import '../../providers/p_audio.dart';
import '../../values.dart';
import '../auto_scroll_text.dart';
import '../progress_bar.dart';

class WidgetSongPlayer extends StatefulWidget {
  const WidgetSongPlayer({
    Key? key,
    required this.onPlayTap,
    required this.onPauseTap,
    required this.onSeekToNext,
    required this.onSeekToPrevious,
  }) : super(key: key);

  final Function() onPlayTap;
  final Function() onPauseTap;
  final VoidCallback onSeekToNext;
  final VoidCallback onSeekToPrevious;

  @override
  State<WidgetSongPlayer> createState() => _WidgetSongPlayerState();
}

class _WidgetSongPlayerState extends State<WidgetSongPlayer> {
  String lastMediaItemId = "";

  @override
  Widget build(BuildContext context) {
    bool isPlaying =
        Provider.of<PAudio>(context).playbackState?.playing ?? false;

    MediaItem? mediaItem = Provider.of<PAudio>(context).mediaItem;

    Audio audio = Provider.of<PAudio>(context).audio;

    if (mediaItem == null) return const SizedBox.shrink();

    if (lastMediaItemId != mediaItem.id) {
      lastMediaItemId = mediaItem.id.toString();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: context.paddingNormal,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: cPrimaryColor,
          borderRadius: context.lowBorderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: context.paddingLow,
              child: Row(
                children: [
                  _texts(mediaItem),
                  _iconButtonSeekPrevious(),
                  _iconButtonPlayPause(isPlaying),
                  _iconButtonSeekNext(),
                  _iconButtonArrowUp(),
                ],
              ),
            ),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: audio.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                    durationMax: value.total, durationCurrent: value.current);
              },
            ),
          ],
        ),
      ),
    );
  }

  IconButton _iconButtonArrowUp() {
    return IconButton(
      onPressed: () {
        context.navigateToPage(const SongPageView());
      },
      icon: const Icon(Icons.keyboard_arrow_up_outlined),
    );
  }

  Expanded _texts(MediaItem mediaItem) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoScrollText(
              text: mediaItem.title,
              textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          AutoScrollText(
            text: mediaItem.artist!,
          ),
        ],
      ),
    );
  }

  IconButton _iconButtonSeekPrevious() {
    return IconButton(
      onPressed: widget.onSeekToPrevious,
      icon: const Icon(Icons.skip_previous),
    );
  }

  IconButton _iconButtonPlayPause(bool isPlaying) {
    return IconButton(
      onPressed: () {
        if (isPlaying) {
          widget.onPauseTap.call();
        } else {
          widget.onPlayTap.call();
        }
      },
      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
    );
  }

  IconButton _iconButtonSeekNext() {
    return IconButton(
      onPressed: widget.onSeekToNext,
      icon: const Icon(Icons.skip_next),
    );
  }
}
