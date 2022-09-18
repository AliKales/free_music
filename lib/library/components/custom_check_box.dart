import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
    required this.onCheckChane,
    required this.isListEmpty,
  }) : super(key: key);

  final Function(bool) onCheckChane;
  final bool isListEmpty;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;

  @override
  void didUpdateWidget(covariant CustomCheckBox oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (widget.isListEmpty && isChecked) {
      setState(() {
        isChecked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onCheckChane.call(isChecked);
      },
    );
  }
}
