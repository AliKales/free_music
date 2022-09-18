import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/components/custom_bottom_bar/custom_bottom_bar_view.dart';
import 'package:music_app/library/components/custom_textfield.dart';
import 'package:music_app/library/models/model_playlist.dart';
import 'package:music_app/library/providers/p_home_page.dart';
import 'package:provider/provider.dart';

import '../../components/custom_check_box.dart';
import '../../components/widget_song_small.dart';
import '../../models/model_song.dart';
import '../../services/hive/hive_db.dart';
import '../home_page/home_page_view.dart';

class NewPlaylistPageView extends StatefulWidget {
  const NewPlaylistPageView({Key? key}) : super(key: key);

  @override
  State<NewPlaylistPageView> createState() => _NewPlaylistPageViewState();
}

class _NewPlaylistPageViewState extends State<NewPlaylistPageView> {
  List<ModelSong> songs = [];

  List<String> songsPlaylist = [];

  TextEditingController tECTitle = TextEditingController();

  final _title = "Create Playlist";

  @override
  void initState() {
    super.initState();

    songs = HiveDB().getSongs() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomButtomBar(
        onFloatingButtonTap: _onFloatingButtonTap,
        iconFloatButton: Icons.save,
        iconButtons: [
          IconButton(
            onPressed: () {
              setState(() {
                songsPlaylist.clear();
              });
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: Column(
          children: [
            CustomTextField.outlined(
              labelText: "Playlist title",
              tEC: tECTitle,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) => Row(
                  children: [
                    Expanded(
                      child: WidgetSongSmall(
                        song: songs[index],
                        onTap: () {},
                      ),
                    ),
                    CustomCheckBox(
                      isListEmpty: songsPlaylist.isEmpty,
                      onCheckChane: (p0) {
                        if (p0) {
                          songsPlaylist.add(songs[index].id!);
                        } else {
                          songsPlaylist.remove(songs[index].id!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onFloatingButtonTap() async {
    if (tECTitle.text.trim() == "" || songsPlaylist.isEmpty) return;

    var rng = Random();

    int id = 0;

    while (true) {
      id = rng.nextInt(999999);

      if (!HiveDB().checkPlaylistExisting(id)) {
        break;
      }
    }

    ModelPlaylist playlist = ModelPlaylist(
        id: id,
        createdDate: DateTime.now(),
        songIds: songsPlaylist,
        title: tECTitle.text.trim());

    await HiveDB().addPlaylist(playlist);
    Provider.of<PHomePage>(context, listen: false).addPlaylist(playlist);

    Navigator.pop(context, playlist);
  }
}
