part of 'search_page_view.dart';

mixin _Mixin<T extends StatefulWidget> on State<T> {
  Future<ModelSong?> fetchLink(String url) async {
    if (await checkSongExisting(url.split("watch?v=").last)) return null;

    return await ServiceYoutube().fetchSong(url.trim(), context);
  }

  Future<bool> checkSongExisting(String id) async {
    return File("$appDocPathToSongs/$id.mp3").exists();
  }

  Future<bool> _onSongClicked(ModelSong song) async {
    bool result = await ServiceYoutube()
        .downloadSongFromUrl(song.songDownloadUrl ?? "", song.id!, context);

    if (result) {
      HiveDB().addSong(song);
      Provider.of<PHomePage>(context, listen: false).addSong(song);
    }

    return result;
  }

  String refactorLink(String link) {
    link = link.trim();

    if (link.contains("youtu.be")) {
      link = link.replaceAll("youtu.be/", "www.youtube.com/watch?v=");
    }

    if (!link.contains("https://")) {
      link = "https://$link";
    }

    return link;
  }

  bool checkLink(String link) {
    bool result1 = link.contains("https://www.youtube.com/watch?v=");
    bool result2 = link.split("watch?v=").length == 2;

    return result1 && result2;
  }
}
