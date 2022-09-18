import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../models/model_playlist.dart';
import '../values.dart';

class WidgetPlaylist extends StatefulWidget {
  const WidgetPlaylist({
    Key? key,
    required this.playlist,
    this.onSelectedChange,
    this.onTap,
  }) : super(key: key);

  final ModelPlaylist playlist;
  final Function(bool)? onSelectedChange;
  final VoidCallback? onTap;

  @override
  State<WidgetPlaylist> createState() => _WidgetPlaylistState();
}

class _WidgetPlaylistState extends State<WidgetPlaylist> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Row(
            children: [
              const Icon(Icons.arrow_forward_ios),
              Expanded(child: _mainWidget()),
              SizedBox(width: context.dynamicWidth(0.02)),
              const Icon(Icons.arrow_back_ios),
            ],
          )
        : _mainWidget();
  }

  Card _mainWidget() {
    return Card(
      child: Padding(
        padding: context.paddingLow,
        child: InkWell(
          onLongPress: () {
            setState(() {
              isSelected = !isSelected;
            });

            widget.onSelectedChange?.call(isSelected);
          },
          onTap: widget.onTap,
          child: Row(
            children: [
              Container(
                width: context.dynamicWidth(0.2),
                height: context.dynamicWidth(0.2),
                decoration: BoxDecoration(
                  color: cThirdColor,
                  borderRadius: context.normalBorderRadius,
                ),
                child: const Center(
                  child: Icon(
                    Icons.playlist_play_rounded,
                  ),
                ),
              ),
              SizedBox(width: context.dynamicWidth(0.03)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.playlist.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                    const Text("Playlist"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
