import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:music_app/library/models/model_genius.dart';
import 'package:music_app/library/no_github.dart';

abstract class IServiceGenius {
  IServiceGenius();

  Future<List<ModelGenius>?> searchSongs(String search);
}

class ServiceGenius extends IServiceGenius {
  ServiceGenius() : super();

  final String baseUrl = "https://api.genius.com/";

  @override
  Future<List<ModelGenius>?> searchSongs(String search) async {
    final response = await Dio()
        .get("${baseUrl}search?q=$search&access_token=$geniusAccessToken");

    if (response.statusCode != 200) return null;

    final Map<String, dynamic> jsonBody = response.data;

    if (jsonBody['meta']['status'] != 200) return null;

    var songs = jsonBody['response']['hits'];

    if (songs is List) {
      return songs.map((e) => ModelGenius.fromJson(e['result'])).toList();
    }

    return null;
  }
}
