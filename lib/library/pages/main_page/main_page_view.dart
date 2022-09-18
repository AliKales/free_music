import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_app/library/audio/audio.dart';
import 'package:music_app/library/pages/main_page/main_page_page_view.dart';
import 'package:music_app/library/utilities/version_check.dart';
import 'package:provider/provider.dart';

import '../../components/custom_bottom_nav_bar/custom_bottom_nav_bar_view.dart';
import '../../components/widget_song_player/widget_song_player_view.dart';
import '../../providers/p_audio.dart';
import '../../providers/p_page.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({Key? key}) : super(key: key);

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  late Audio audio;
  AudioHandler? audioHandler;

  @override
  void initState() {
    super.initState();
    VersionCheck().launchVersionChecker(context);
    _handleAudios();
  }

  Future<void> _handleAudios() async {
    audio = Provider.of<PAudio>(context, listen: false).audio;
    audioHandler = await audio.init();

    audioHandler?.playbackState.listen((event) {
      Provider.of<PAudio>(context, listen: false).setPlaybackState(event);
    });

    audioHandler?.mediaItem.listen((event) {
      Provider.of<PAudio>(context, listen: false).setMediaItem(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    int currentPage = Provider.of<PPage>(context).currentPage;
    return Scaffold(
      body: Stack(
        children: [
          MainPagePageView(selectedPage: currentPage),
          WidgetSongPlayer(
            onPauseTap: () => audio.stop(),
            onPlayTap: () => audio.play(),
            onSeekToNext: () => audio.seekToNext(),
            onSeekToPrevious: () => audio.seekToPrevious(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedPage: currentPage,
      ),
    );
  }
}
