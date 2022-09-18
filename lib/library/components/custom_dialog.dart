import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> showMyDialog({
    required BuildContext context,
    String? title,
    String? text,
    List<Widget>? actions,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title??""),
          content: Text(text ?? ""),
          actions: actions,
        );
      },
    );
  }
}
