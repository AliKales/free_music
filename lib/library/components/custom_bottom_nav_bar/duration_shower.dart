import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/p_audio.dart';

class DurationShower extends StatefulWidget {
  const DurationShower({
    Key? key,
  }) : super(key: key);

  @override
  State<DurationShower> createState() => _DurationShowerState();
}

class _DurationShowerState extends State<DurationShower> {
  @override
  Widget build(BuildContext context) {
    double value = 0;
    int percent = 0;

    Duration? postion =
        Provider.of<PAudio>(context).playbackState?.updatePosition;

    Duration? duration = Provider.of<PAudio>(context).mediaItem?.duration;

    if (postion != null && duration != null) {
      percent = 100 * postion.inMilliseconds ~/ duration.inMilliseconds;
    }

    if (percent != 0) value = (1 / percent) * 10;

    return LinearProgressIndicator(value: value);
  }
}
