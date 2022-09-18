import 'package:flutter/src/widgets/framework.dart';
import 'package:music_app/library/services/unity_ads/s_unity_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class WidgetUnityBannerAd extends StatelessWidget {
  const WidgetUnityBannerAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnityBannerAd(
      placementId: Ads.banner.id,
    );
  }
}
