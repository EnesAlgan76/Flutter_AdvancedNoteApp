import 'package:applovin_max/applovin_max.dart';
import 'package:e_note_app/screens/noteMainPage.dart';
import 'package:flutter/material.dart';

class AddManager{

  static Future<void> initApplovin() async {
    await AppLovinMAX.initialize(
      "LLyxefiqREW2U3KT_76iReQ0M9OGMUBq7gUVC3THt7fFyDQxF8NhzTvIvAu0cbV3lmLJf3CkbnvEdRgwzT4906",
    );
    //List<String> testDeviceIds = ["53d7cc40-aac2-4971-9768-18bb1e53acbb","2b3b8ada-170d-44d0-94c7-2d8b5a0daba7"];
    //AppLovinMAX.setTestDeviceAdvertisingIds(testDeviceIds);
  }

  static Widget buildBannerAdContainer() {
    return MaxAdView(
        adUnitId: "c07ce7925258be0b",
        adFormat: AdFormat.banner,
        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
          printWarning('BANNER widget ad loaded from ${ad.networkName}');
        }, onAdLoadFailedCallback: (adUnitId, error) {
          printWarning('BANNER widget ad failed to load with error code ${error.code} and message: ${error.message}');
        }, onAdClickedCallback: (ad) {
          printWarning('BANNER widget ad clicked');
        }, onAdExpandedCallback: (ad) {
          printWarning('BANNER widget ad expanded');
        }, onAdCollapsedCallback: (ad) {
          printWarning('BANNER widget ad collapsed');
        }, onAdRevenuePaidCallback: (ad) {
          printWarning('BANNER widget ad revenue paid: ${ad.revenue}');
        }));
  }



  static Widget buildBannerAdContainer2() {
    return MaxAdView(
        adUnitId: "bbf2063c27b7bb43",
        adFormat: AdFormat.banner,
        listener: AdViewAdListener(onAdLoadedCallback: (ad) {
          printWarning('BANNER widget ad loaded from ${ad.networkName}');
        }, onAdLoadFailedCallback: (adUnitId, error) {
          printWarning('BANNER widget ad failed to load with error code ${error.code} and message: ${error.message}');
        }, onAdClickedCallback: (ad) {
          printWarning('BANNER widget ad clicked');
        }, onAdExpandedCallback: (ad) {
          printWarning('BANNER widget ad expanded');
        }, onAdCollapsedCallback: (ad) {
          printWarning('BANNER widget ad collapsed');
        }, onAdRevenuePaidCallback: (ad) {
          printWarning('BANNER widget ad revenue paid: ${ad.revenue}');
        }));
  }


}