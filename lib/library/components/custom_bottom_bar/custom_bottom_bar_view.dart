import 'package:flutter/material.dart';

import '../../values.dart';

class CustomButtomBar extends StatelessWidget {
  const CustomButtomBar(
      {this.isElevated = false,
      this.isVisible = true,
      this.onFloatingButtonTap,
      this.iconButtons,
      this.iconFloatButton});

  final bool? isElevated;
  final bool? isVisible;
  final VoidCallback? onFloatingButtonTap;
  final List<IconButton>? iconButtons;
  final IconData? iconFloatButton;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: cPrimaryColor,
      duration: const Duration(milliseconds: 200),
      child: BottomAppBar(
        color: cPrimaryColor,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 13),
          child: Row(
            children: <Widget>[
              ...List.generate(
                iconButtons?.length ?? 0,
                (index) => _item(index, context),
              ),
              const Spacer(),
              if (onFloatingButtonTap != null)
                FloatingActionButton(
                  onPressed: onFloatingButtonTap,
                  elevation: 0,
                  child: Icon(iconFloatButton),
                ),
            ],
          ),
        ),
      ),
    );
  }

  _item(int index, context) {
    return iconButtons![index];
  }
}
