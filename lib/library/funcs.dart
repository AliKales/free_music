import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_app/library/values.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Funcs {
  Future<dynamic> navigatorPush(context, page) async {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    var object = await Navigator.push(context, route);
    return object;
  }

  void navigatorPushReplacement(context, page) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => page);
    Navigator.pushReplacement(context, route);
  }

  Future<bool> checkPermission() async {
    final status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    } else {
      return true;
    }

    return false;
  }

  bool checkLastItem(int index, int length) => index == length;

  void setSystemUIColors() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // status bar color
          systemNavigationBarColor: cPrimaryColor,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
  }

  Future<void> setPath() async {
    var path = await getExternalStorageDirectory();
    appDocPath = path!.path;
    appDocPathToSongs = "${path.path}/songs";
  }
}
