import 'package:music_app/library/no_github.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class SUnityAds {
  void init() {
    UnityAds.init(
      gameId: unityGameId,
    );
  }

  static void showAd({
    required Ads ad,
    Function()? onFailed,
    Function()? onLoadFailed,
    Function()? onComplete,
  }) {
    UnityAds.load(
      placementId: ad.id,
      onComplete: (placementId) => SUnityAds._openAd(
        ad: ad,
        onFailed: () => onFailed?.call(),
        onComplete: () => onComplete?.call(),
      ),
      onFailed: (placementId, error, message) => onLoadFailed?.call(),
    );
  }

  static void _openAd({
    required Ads ad,
    Function()? onFailed,
    Function()? onComplete,
  }) {
    UnityAds.showVideoAd(
      placementId: ad.id,
      onComplete: (placementId) => onComplete?.call(),
      onFailed: (placementId, error, message) => onFailed?.call(),
    );
  }
}

enum Ads {
  interstitial("Interstitial_Android"),
  rewarded("Rewarded_Android"),
  banner("Banner_Android");

  const Ads(this.id);
  final String id;
}
