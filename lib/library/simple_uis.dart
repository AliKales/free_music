import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/values.dart';

import 'components/custom_textfield.dart';

class SimpleUIs {
  Widget divider(BuildContext context) {
    return Column(children: [
      SizedBox(height: context.dynamicHeight(0.02)),
      const Divider(),
      SizedBox(height: context.dynamicHeight(0.02)),
    ]);
  }

  void showSnackBar(BuildContext context, String text) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: context.lowBorderRadius,
        ),
      ),
    );
  }

  Future showProgressIndicator(context) async {
    FocusScope.of(context).unfocus();
    if (ModalRoute.of(context)?.isCurrent ?? true) {
      await showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: false,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: const Duration(milliseconds: 500),
          context: context,
          pageBuilder: (_, __, ___) {
            return WillPopScope(
              onWillPop: () async => false,
              child: progressIndicator(),
            );
          });
    }
  }

  static Widget progressIndicator() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  static void showCustomModalBottomSheet({
    required BuildContext context,
    required Widget child,
  }) {
    showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: context.lowRadius,
        ),
      ),
      builder: (_) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            builder: (context, controller) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 173, 173, 173),
                        borderRadius: BorderRadius.all(
                          context.lowRadius,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget showDropdownButton({
    required context,
    required List<String> list,
    required Function(Object?) onChanged,
    required var dropdownValue,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownButton(
          value: dropdownValue,
          hint: const CustomTextField.outlined(labelText: "Search"),
          items: List.generate(list.length,
              (index) => _widgetDropDownMenuItem(value: list[index])),
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
            onChanged.call(value);
          },
        );
      },
    );
  }

  static DropdownMenuItem<String> _widgetDropDownMenuItem(
      {required String value}) {
    return DropdownMenuItem(
      value: value,
      child: Text(value.toUpperCase()),
    );
  }

  static Future dialogCustom({
    required context,
    required String title,
    required String description,
    List<Widget>? buttons,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: cPrimaryColor,
          child: Padding(
            padding: context.paddingMedium,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: context.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(description, style: context.textTheme.bodyLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: buttons ?? [],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget songPlayerSpace(BuildContext context) => SizedBox(
        width: 10,
        height: context.dynamicHeight(0.2),
      );
}
