import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({
    Key? key,
    required this.durationMax,
    required this.durationCurrent,
  }) : super(key: key);

  final Duration durationMax;
  final Duration durationCurrent;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final value = min(
      widget.durationMax.inMilliseconds.toDouble(),
      widget.durationCurrent.inMilliseconds.toDouble(),
    );

    return Padding(
      padding: context.horizontalPaddingLow,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbColor: Colors.transparent,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 3,
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: Slider.adaptive(
          max: widget.durationMax.inMilliseconds.toDouble(),
          value: value,
          thumbColor: Colors.transparent,
          onChanged: (value) {},
        ),
      ),
    );
  }
}
