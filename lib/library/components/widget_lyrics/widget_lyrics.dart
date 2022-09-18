import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../models/model_genius.dart';
import '../../models/model_song.dart';
import '../../services/hive/hive_db.dart';
import '../../services/dio/service_genius.dart';
import '../../services/dio/service_lyrics.dart';
import '../../simple_uis.dart';
import '../../values.dart';
import '../custom_textfield.dart';
import '../widget_song_small.dart';

class WidgetLyrics extends StatefulWidget {
  const WidgetLyrics({
    Key? key,
    this.song,
    this.height,
    required this.isGeniused,
  }) : super(key: key);

  final ModelSong? song;
  final double? height;
  final bool isGeniused;

  @override
  State<WidgetLyrics> createState() => _WidgetLyricsState();
}

class _WidgetLyricsState extends State<WidgetLyrics> {
  ModelSong? _song;
  bool isLoading = false;
  List<ModelGenius>? modelGeniuss;
  TextEditingController? _tEC;
  final ScrollController _sc = ScrollController();

  final _textNoItem =
      "No Item Found!\nPlease try again\n\nExample: Eminem Without me \nIt must not contain other texts such as '(Official)'";

  @override
  void initState() {
    super.initState();
    _song = widget.song;
  }

  @override
  void didUpdateWidget(covariant WidgetLyrics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.song?.id == oldWidget.song?.id) return;
    _song = widget.song;
    modelGeniuss = null;
    _tEC?.clear();
    isLoading = false;
  }

  @override
  void dispose() {
    _sc.dispose();
    _tEC?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_song == null) return const SizedBox.shrink();
    if (widget.height != null) return _mainWidget();
    return Expanded(
      child: _mainWidget(),
    );
  }

  Container _mainWidget() {
    return Container(
      width: double.maxFinite,
      height: widget.height,
      decoration: BoxDecoration(
        color: cPrimaryColor,
        borderRadius: widget.isGeniused
            ? BorderRadius.vertical(top: context.normalRadius)
            : context.normalBorderRadius,
      ),
      padding: context.paddingNormal,
      child: _widget(),
    );
  }

  Widget _widget() {
    if (isLoading) {
      return SimpleUIs.progressIndicator();
    } else if (_song!.lyrics != null) {
      return _lyrics();
    } else if (modelGeniuss != null) {
      return _widgetModelGenius();
    } else {
      _tEC = TextEditingController(text: _song?.title ?? "");
      return _searchLyrics();
    }
  }

  SingleChildScrollView _lyrics() {
    return SingleChildScrollView(
      controller: _sc,
      child: Column(
        children: [
          Text(
            _song?.lyrics ?? "",
            style: context.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          if (modelGeniuss != null) ButtonDisable(song: _song),
        ],
      ),
    );
  }

  Column _widgetModelGenius() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Select the Correct Lyrics"),
            IconButton(
              onPressed: () {
                setState(() {
                  modelGeniuss = null;
                });
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        modelGeniuss!.isEmpty
            ? Center(
                child: Text(
                  _textNoItem,
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: modelGeniuss!.length,
                  itemBuilder: (context, index) {
                    ModelGenius modelGenius = modelGeniuss![index];

                    return WidgetSongSmall(
                      iconData: Icons.music_note,
                      onTap: () async {
                        _changeLoading();

                        String? result = await ServiceLyrics()
                            .getLyrics(modelGenius.url ?? "");

                        _song!.lyrics = result;
                        _song!.thumbnail = modelGenius.thumbnail;

                        _changeLoading();

                        await Future.delayed(context.durationLow);

                        _sc.animateTo(_sc.position.maxScrollExtent,
                            duration: context.durationNormal,
                            curve: Curves.bounceIn);
                      },
                      song: ModelSong(
                        title: modelGenius.titleWithFeatured,
                        authorName: modelGenius.artistNames,
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _searchLyrics() {
    return Column(
      children: [
        CustomTextField.outlined(
          labelText: "Song Name - Artist",
          tEC: _tEC,
          onSubmitted: (value) async {
            _changeLoading();

            modelGeniuss = await ServiceGenius().searchSongs(value.trim());

            _changeLoading();
          },
        ),
      ],
    );
  }

  void _changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}

class ButtonDisable extends StatefulWidget {
  const ButtonDisable({
    Key? key,
    required ModelSong? song,
  })  : _song = song,
        super(key: key);

  final ModelSong? _song;

  @override
  State<ButtonDisable> createState() => _ButtonDisableState();
}

class _ButtonDisableState extends State<ButtonDisable> {
  bool isShown = true;

  @override
  Widget build(BuildContext context) {
    if (!isShown) return const SizedBox.shrink();
    return ElevatedButton(
      onPressed: () {
        HiveDB().updateSongById(widget._song!);
        setState(() {
          isShown = false;
        });
        SimpleUIs().showSnackBar(context, "Saved!");
      },
      child: const Text("Save Lyrics"),
    );
  }
}
