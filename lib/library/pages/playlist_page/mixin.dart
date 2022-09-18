part of 'playlist_page_view.dart';

mixin _Mixin on State<PlaylistPageView> {
  Future<bool> _toAddSongsPage() async {
    List<ModelSong> getSongs =
        HiveDB().getUnAddedSongs(widget.playlist.songIds);

    List<int>? result = await context.navigateToPage(PickSmthngPageView(
      items: getSongs,
    ));

    if (result.isNullOrEmpty) return false;

    List<String> ids = List.generate(
      result!.length,
      (index) => getSongs[index].id!,
    );

    await HiveDB().addSongsToPlaylist(widget.playlist.id, ids);
    return true;
  }
}
