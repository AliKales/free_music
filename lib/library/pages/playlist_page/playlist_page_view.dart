import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/components/custom_bottom_bar/custom_bottom_bar_view.dart';
import 'package:music_app/library/models/model_playlist.dart';
import 'package:music_app/library/models/model_song.dart';
import 'package:music_app/library/pages/pick_smthng_page/pick_smthgn_page_view.dart';
import 'package:music_app/library/services/hive/hive_db.dart';

import '../../components/widget_song_small.dart';

part 'mixin.dart';

class PlaylistPageView extends StatefulWidget {
  const PlaylistPageView({Key? key, required this.playlist}) : super(key: key);

  final ModelPlaylist playlist;

  @override
  State<PlaylistPageView> createState() => _PlaylistPageViewState();
}

class _PlaylistPageViewState extends State<PlaylistPageView> with _Mixin {
  List<ModelSong> songs = [];
  List<String> selectedSongIds = [];

  @override
  void initState() {
    super.initState();
    _loadSongsFromHive();
  }

  void _loadSongsFromHive() {
    songs = HiveDB().getSongByIds(widget.playlist.songIds) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverSafeArea(
              top: false,
              sliver: SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                primary: true,
                forceElevated: innerBoxIsScrolled,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SizedBox(
                    height: const Size.fromHeight(kToolbarHeight).height,
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          SizedBox(width: context.dynamicWidth(0.05)),
                          Text(
                            widget.playlist.title,
                            style: context.textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Padding(
          padding: context.paddingNormal,
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) => WidgetSongSmall(
              song: songs[index],
              onLongPress: (p0) {
                if (p0) {
                  selectedSongIds.add(songs[index].id!);
                } else {
                  selectedSongIds.removeAt(index);
                }
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomButtomBar(
        onFloatingButtonTap: _onFloatingButtonTap,
        iconFloatButton: Icons.add,
        iconButtons: _icons(),
      ),
    );
  }

  List<IconButton> _icons() {
    return [
      IconButton(
        onPressed: () async {
          await HiveDB()
              .deleteSongsFromPlaylist(widget.playlist.id, selectedSongIds);

          for (var id in selectedSongIds) {
            songs.removeWhere((element) => element.id == id);
          }

          setState(() {
            selectedSongIds.clear();
          });
        },
        icon: const Icon(Icons.delete),
      ),
    ];
  }

  Future<void> _onFloatingButtonTap() async {
    final result = await _toAddSongsPage();

    if (!result) return;

    _loadSongsFromHive();

    setState(() {});
  }
}
