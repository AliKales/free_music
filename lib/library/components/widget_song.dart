import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../models/model_song.dart';

class WidgetSong extends StatelessWidget {
  const WidgetSong({
    Key? key,
    required ModelSong? song,
    this.onTap,
  })  : _song = song,
        super(key: key);

  final ModelSong? _song;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: context.paddingNormal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _thumbnailAndInfos(context),
              SizedBox(width: context.dynamicWidth(0.02)),
              _authorAndTitle(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thumbnailAndInfos(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(context.lowRadius),
      child: CachedNetworkImage(
        imageUrl: _song!.thumbUrl!,
        width: context.dynamicWidth(0.45),
        height: context.dynamicWidth(0.35),
        fit: BoxFit.fill,
      ),
    );
  }

  Expanded _authorAndTitle(BuildContext context) {
    return Expanded(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "${_song!.authorName} ● ",
            ),
            TextSpan(
              text: _song!.title,
            ),
          ],
          style: context.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
