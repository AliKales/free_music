import 'package:flutter/material.dart';

class AutoScrollText extends StatefulWidget {
  const AutoScrollText({
    Key? key,
    required this.text,
    this.textStyle,
  }) : super(key: key);

  final String text;
  final TextStyle? textStyle;

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  String text = "";

  final GlobalKey _keyTitle = GlobalKey();
  final GlobalKey _keyTitleScrollView = GlobalKey();

  final ScrollController _scTitle = ScrollController();

  Duration durationWait = const Duration(seconds: 2);
  Duration? durationGo;

  int speed = 2000;

  bool _handleScroll = false;

  Future<void> _handleScrolls(_) async {
    _handleScroll = true;

    if (durationGo == null && _checkWidth()) {
      _calculateDurationGo();
    }

    if (durationGo == null) return;

    await Future.delayed(durationWait).then((value) => _scTitle.animateTo(
        _scTitle.position.maxScrollExtent,
        duration: durationGo!,
        curve: Curves.ease));

    await Future.delayed(durationWait).then((value) =>
        _scTitle.animateTo(0, duration: durationGo!, curve: Curves.ease));
    await Future.delayed(durationWait).then((value) => _handleScrolls(_));
  }

  void _calculateDurationGo() {
    try {
      _scTitle.jumpTo(0);
    } catch (e) {}

    double milliseconds = (_keyTitle.currentContext!.size!.width /
            _keyTitleScrollView.currentContext!.size!.width) *
        speed;

    durationGo = Duration(milliseconds: milliseconds.toInt());
  }

  bool _checkWidth() =>
      _keyTitleScrollView.currentContext!.size!.width <=
      _keyTitle.currentContext!.size!.width;

  @override
  void didUpdateWidget(covariant AutoScrollText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text == text) return;

    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateDurationGo());
  }

  @override
  void initState() {
    super.initState();

    text = widget.text;

    if (_handleScroll == false) {
      WidgetsBinding.instance.addPostFrameCallback(_handleScrolls);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateDurationGo());
  }

  @override
  void dispose() {
    _scTitle.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scTitle,
      key: _keyTitleScrollView,
      scrollDirection: Axis.horizontal,
      child: Text(
        widget.text,
        key: _keyTitle,
        style: widget.textStyle,
        maxLines: 1,
      ),
    );
  }
}
