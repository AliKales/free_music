class ModelGenius {
  String? titleWithFeatured;
  String? artistNames;
  String? url;
  String? thumbnail;

  ModelGenius(
      {this.titleWithFeatured, this.artistNames, this.url, this.thumbnail});

  ModelGenius.fromJson(Map<String, dynamic> json) {
    titleWithFeatured = json['title_with_featured'];
    artistNames = json['artist_names'];
    url = json['url'];
    thumbnail = json['song_art_image_thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title_with_featured'] = titleWithFeatured;
    data['artist_names'] = artistNames;
    data['url'] = url;
    data['song_art_image_url'] = thumbnail;
    return data;
  }
}
