import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../models/model_song.dart';

class WidgetSongSmall extends StatefulWidget {
  const WidgetSongSmall({
    Key? key,
    required this.song,
    this.onTap,
    this.onLongPress,
    this.iconData,
  }) : super(key: key);

  final ModelSong song;
  final VoidCallback? onTap;
  final Function(bool)? onLongPress;
  final IconData? iconData;

  @override
  State<WidgetSongSmall> createState() => _WidgetSongSmallState();
}

class _WidgetSongSmallState extends State<WidgetSongSmall> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
        });

        widget.onLongPress?.call(isSelected);
      },
      onTap: widget.onTap,
      child: isSelected
          ? Row(
              children: [
                const Icon(Icons.arrow_forward_ios),
                Expanded(child: _widgetMain()),
                SizedBox(width: context.dynamicWidth(0.02)),
                const Icon(Icons.arrow_back_ios),
              ],
            )
          : _widgetMain(),
    );
  }

  Card _widgetMain() {
    return Card(
      shadowColor: Colors.transparent,
      child: Padding(
        padding: context.paddingLow,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  Text(
                    widget.song.authorName!,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(widget.iconData ?? Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}
