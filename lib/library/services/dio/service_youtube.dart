// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_app/library/models/model_song.dart';
import 'package:music_app/library/simple_uis.dart';
import 'package:music_app/library/values.dart';

import '../../no_github.dart';

class ServiceYoutube {
  Future<ModelSong?> fetchSong(String url, BuildContext context) async {
    ModelSong? modelSong;

    Map? songInfos = await _getSongInfos(url, context);

    if (songInfos == null) return null;

    Map<String, dynamic>? songResult = await _getSongInfo(url, context);

    if (songResult == null) return null;

    modelSong = ModelSong.fromJson({...songInfos, ...songResult});

    return modelSong;
  }

  Future<Map<String, dynamic>?> _getSongInfo(
      String url, BuildContext context) async {
    var headers = {
      'X-RapidAPI-Key': xRapidApiKey,
      'X-RapidAPI-Host': 'youtube-mp36.p.rapidapi.com'
    };

    String youtubeVideoId = url.split("watch?v=").last;

    var songResult = await Dio().get(
      "https://youtube-mp36.p.rapidapi.com/dl?id=$youtubeVideoId",
      options: Options(headers: headers),
    );

    if (songResult.statusCode != 200) {
      SimpleUIs()
          .showSnackBar(context, "Error Code: SY1 ${songResult.statusCode}");

      return null;
    }

    return jsonDecode(songResult.data);
  }

  Future<Map?> _getSongInfos(String url, BuildContext context) async {
    try {
      var resultForAuthor =
          await Dio().get("https://noembed.com/embed?url=$url");

      if (resultForAuthor.statusCode == 200) {
        var resultForAuthorDecode = jsonDecode(resultForAuthor.data);

        return resultForAuthorDecode;
      } else {
        SimpleUIs().showSnackBar(
            context, "Error Code: SY2 ${resultForAuthor.statusCode}");

        return null;
      }
    } catch (e) {
      String error = e.toString();

      if (error.contains("Failed host lookup")) {
        SimpleUIs()
            .showSnackBar(context, "You need to turn on device internet");
      } else {
        SimpleUIs().showSnackBar(context, "Error Code: SY2.5 $e");
      }

      return null;
    }
  }

  Future<bool> downloadSongFromUrl(
      String url, String youtubeId, BuildContext context) async {
    try {
      String audios = appDocPathToSongs;

      final savedDir = Directory("$audios/");
      final hasExisted = savedDir.existsSync();
      if (!hasExisted) {
        await savedDir.create();
      }

      if (await File("$audios/$youtubeId.mp3").exists()) return false;

      await Dio().download(url, "$audios/$youtubeId.mp3");

      return true;
    } catch (e) {
      String error = e.toString();

      if (error.contains("Failed host lookup")) {
        SimpleUIs()
            .showSnackBar(context, "You need to turn on device internet");
      } else {
        SimpleUIs().showSnackBar(context, "Error Code: SY3 $e");
      }

      return false;
    }
  }
}
