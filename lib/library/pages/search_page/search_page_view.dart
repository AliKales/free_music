import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/funcs.dart';
import 'package:music_app/library/models/model_song.dart';
import 'package:music_app/library/providers/p_home_page.dart';
import 'package:music_app/library/services/hive/hive_db.dart';
import 'package:music_app/library/services/unity_ads/s_unity_ads.dart';
import 'package:music_app/library/simple_uis.dart';
import 'package:music_app/library/values.dart';
import 'package:provider/provider.dart';

import '../../components/custom_textfield.dart';
import '../../components/widget_song.dart';
import '../../services/dio/service_youtube.dart';

part 'mixin.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key? key}) : super(key: key);

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> with _Mixin {
  ModelSong? _song;

  String title = "Search for Songs";

  final TextEditingController _tECSearch = TextEditingController();

  int _rewardedAdCounter = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: Column(
          children: [
            CustomTextField(
              tEC: _tECSearch,
              labelText: "Youtube Link",
              onSubmitted: _handleOnSubmitted,
            ),
            if (_song != null) WidgetSong(song: _song, onTap: _onTap),
          ],
        ),
      ),
    );
  }

  Future<void> _onTap() async {
    SimpleUIs().showProgressIndicator(context);

    bool result = await _onSongClicked(_song!);

    Navigator.pop(context);

    if (!result) return;

    _tECSearch.clear();
    _song = null;

    setState(() {});
  }

  Future<void> _handleOnSubmitted(String val) async {
    if (!await Funcs().checkPermission()) return;

    val = refactorLink(val);

    if (!checkLink(val)) {
      SimpleUIs.dialogCustom(
          context: context,
          title: "Wrong Link",
          description:
              "A sample link;\nhttps://www.youtube.com/watch?v=a2BC34S");

      return;
    }

    SimpleUIs().showProgressIndicator(context);

    if (await checkSongExisting(val.split("watch?v=").last)) {
      Navigator.pop(context);
      SimpleUIs().showSnackBar(context, "This song does already exist");
      return;
    }

    ModelSong? info = await fetchLink(val);

    Navigator.pop(context);

    if (info != null) {
      setState(() {
        _song = info;
      });
    } else {}

    if (_rewardedAdCounter == 3) {
      SUnityAds.showAd(ad: Ads.rewarded);
      _rewardedAdCounter = 0;
    } else if (_rewardedAdCounter == 1) {
      SUnityAds.showAd(ad: Ads.interstitial);
    }
    _rewardedAdCounter++;
  }
}
