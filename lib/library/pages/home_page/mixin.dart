part of 'home_page_view.dart';

mixin _Mixin on State<HomePageView> {
  void _handleOnSongSmallPressed(
      int index, Audio audio, List<ModelSong> songs) {
    List<MediaItem> playlist = List.generate(
      songs.length,
      (index) => MediaItem(
          id: songs[index].id!,
          title: songs[index].title!,
          artUri: Uri.parse(songs[index].thumbUrl!),
          duration: songs[index].duration,
          artist: songs[index].authorName),
    );

    playlist.insert(0, MediaItem(id: index.toString(), title: ""));

    audio.setPlaylist(playlist);
  }

  void loadValued() {
    Provider.of<PHomePage>(context, listen: false).setValuesFromHive();
  }
}
