import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/components/widget_playlist.dart';
import 'package:music_app/library/components/widget_unity_banner_ad.dart';
import 'package:music_app/library/funcs.dart';
import 'package:music_app/library/models/model_playlist.dart';
import 'package:music_app/library/models/model_song.dart';
import 'package:music_app/library/providers/p_audio.dart';
import 'package:music_app/library/providers/p_home_page.dart';
import 'package:music_app/library/simple_uis.dart';
import 'package:music_app/library/values.dart';
import 'package:provider/provider.dart';

import '../../audio/audio.dart';
import '../../components/widget_song_small.dart';

part 'mixin.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView>
    with _Mixin, AutomaticKeepAliveClientMixin<HomePageView> {
  List<ModelSong> songs = [];
  List<ModelPlaylist> playlists = [];
  bool isPlaylistsShown = false;

  final String title = "Home";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadValued());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    songs = Provider.of<PHomePage>(context).songs;
    playlists = Provider.of<PHomePage>(context).playlists;
    Audio audio = Provider.of<PAudio>(context, listen: false).audio;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                title: Text(title),
                floating: true,
                pinned: true,
                snap: false,
                primary: true,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: context.horizontalPaddingNormal,
                    child: Row(
                      children: [
                        _inputChip("Playlists", () {
                          setState(() {
                            isPlaylistsShown = !isPlaylistsShown;
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Padding(
          padding: context.paddingNormal,
          child: isPlaylistsShown
              ? ListView.separated(
                  separatorBuilder: _separatorBuilder,
                  itemCount: playlists.length + 1,
                  itemBuilder: (context, index) {
                    if (Funcs().checkLastItem(index, playlists.length)) {
                      return SimpleUIs().songPlayerSpace(context);
                    }

                    return WidgetPlaylist(playlist: playlists[index]);
                  },
                )
              : ListView.separated(
                  separatorBuilder: _separatorBuilder,
                  itemCount: songs.length + 1,
                  itemBuilder: (context, index) {
                    if (Funcs().checkLastItem(index, songs.length)) {
                      return SimpleUIs().songPlayerSpace(context);
                    } else if (index == 0) {
                      return const WidgetUnityBannerAd();
                    }
                    return WidgetSongSmall(
                      song: songs[index],
                      onTap: () =>
                          _handleOnSongSmallPressed(index, audio, songs),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _separatorBuilder(context, index) {
    if (Funcs().checkLastItem(index, songs.length)) {
      return SimpleUIs().songPlayerSpace(context);
    }

    return const SizedBox.shrink();
  }

  InputChip _inputChip(String text, VoidCallback onPressed) {
    return InputChip(
      label: Text(text),
      selected: isPlaylistsShown,
      selectedColor: cThirdColor,
      backgroundColor: Colors.transparent,
      onPressed: onPressed,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
