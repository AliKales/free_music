import 'package:flutter/material.dart';
import 'package:music_app/library/components/custom_dialog.dart';
import 'package:music_app/library/services/dio/service_version.dart';
import 'package:music_app/library/utilities/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCheck {
  Future<String> checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }

  void launchVersionChecker(BuildContext context) async {
    String versionApp = await checkVersion();

    String? versionGlobal = await ServiceVersion().fetchVersion();

    if (versionGlobal == null) return;

    if (versionGlobal != versionApp) {
      CustomDialog.showMyDialog(
        context: context,
        title: "Update",
        text: "New version is available",
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              UrlLauncher().funLaunchUrl("https://alikales.github.io/dlm/#/");
            },
            child: const Text("Download"),
          ),
        ],
      );
    }
  }
}
