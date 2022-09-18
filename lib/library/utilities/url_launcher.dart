import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  Future<void> funLaunchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication)) {}
  }
}
