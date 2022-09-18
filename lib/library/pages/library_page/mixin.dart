part of 'library_page_view.dart';

mixin _Mixin<T extends StatefulWidget> on State<LibraryPage> {
  void _handleOnTap(Audio audio, ModelPlaylist p) {
    List<ModelSong> songs = HiveDB().getSongByIds(p.songIds) ?? [];

    List<MediaItem> playlist = List.generate(
      songs.length,
      (index) => MediaItem(
          id: songs[index].id!,
          title: songs[index].title!,
          artUri: Uri.parse(songs[index].thumbUrl!),
          duration: songs[index].duration,
          artist: songs[index].authorName),
    );

    playlist.insert(0, const MediaItem(id: "0", title: ""));

    audio.setPlaylist(playlist);
  }

}
