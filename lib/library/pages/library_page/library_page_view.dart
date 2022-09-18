import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/components/widget_playlist.dart';
import 'package:music_app/library/funcs.dart';
import 'package:music_app/library/models/model_playlist.dart';
import 'package:music_app/library/pages/new_playlist_page/new_playlist_page_view.dart';
import 'package:music_app/library/pages/playlist_page/playlist_page_view.dart';
import 'package:music_app/library/services/hive/hive_db.dart';
import 'package:music_app/library/services/unity_ads/s_unity_ads.dart';
import 'package:music_app/library/simple_uis.dart';
import 'package:music_app/library/values.dart';
import 'package:provider/provider.dart';

import '../../audio/audio.dart';
import '../../models/model_song.dart';
import '../../providers/p_audio.dart';

part 'mixin.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> with _Mixin {
  List<ModelPlaylist> playlists = [];

  List<ModelPlaylist> playlistsSelected = [];

  bool isPlaylistEdit = false;

  Audio? audio;

  final String title = "Library";

  @override
  void initState() {
    super.initState();
    audio = Provider.of<PAudio>(context, listen: false).audio;

    _loadPlaylists();
  }

  void _loadPlaylists() {
    playlists = HiveDB().getPlaylists() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          _iconButtonEdit(),
          _iconButtonDelete(),
          _iconButtonAdd(),
        ],
      ),
      body: playlists.isEmpty
          ? _widgetEmpty()
          : Padding(
              padding: context.paddingNormal,
              child: AnimatedContainer(
                duration: context.durationLow,
                decoration: BoxDecoration(
                  border: isPlaylistEdit
                      ? Border.all(color: cThirdColor, width: 3)
                      : null,
                  borderRadius: context.normalBorderRadius,
                ),
                padding: isPlaylistEdit ? context.paddingLow : EdgeInsets.zero,
                child: ListView.builder(
                  itemCount: playlists.length,
                  itemBuilder: (context, index) => WidgetPlaylist(
                    playlist: playlists[index],
                    onTap: () {
                      if (isPlaylistEdit) {
                        context.navigateToPage(
                            PlaylistPageView(playlist: playlists[index]));
                      } else {
                        _handleOnTap(audio!, playlists[index]);
                      }
                    },
                    onSelectedChange: (p0) {
                      if (p0) {
                        playlistsSelected.add(playlists[index]);
                      } else {
                        playlistsSelected.removeAt(index);
                      }
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Center _widgetEmpty() {
    return const Center(
      child: Text("No Playlist Yet"),
    );
  }

  IconButton _iconButtonEdit() {
    return IconButton(
        onPressed: () {
          setState(() {
            isPlaylistEdit = !isPlaylistEdit;
          });
        },
        icon: Icon(isPlaylistEdit ? Icons.close : Icons.edit));
  }

  IconButton _iconButtonDelete() {
    return IconButton(
      onPressed: () async {
        if (playlistsSelected.isEmpty) return;

        await HiveDB().deletePlaylists(playlists);

        _loadPlaylists();

        setState(() {});
      },
      icon: const Icon(Icons.delete),
    );
  }

  IconButton _iconButtonAdd() {
    return IconButton(
      onPressed: () {
        SUnityAds.showAd(
            ad: Ads.rewarded,
            onLoadFailed: () => _navigateNewPlaylist(),
            onComplete: () => _navigateNewPlaylist(),
            onFailed: () {
              SimpleUIs().showSnackBar(
                  context, "You need to watch rewarded ad first!");
            });
      },
      icon: const Icon(Icons.add),
    );
  }

  void _navigateNewPlaylist() async {
    ModelPlaylist? playlist =
        await Funcs().navigatorPush(context, const NewPlaylistPageView());

    if (playlist != null) {
      setState(() {
        playlists.add(playlist);
      });
    }
  }
}
