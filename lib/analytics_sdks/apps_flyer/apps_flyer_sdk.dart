import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_constant.dart'
    as constant;

class AppsFlyerSDK {
  const AppsFlyerSDK._();

  static AppsflyerSdk? _appsflyerSdk;

  static AppsflyerSdk? get appsflyerSdk => _appsflyerSdk;

  static final appsFlyerOptions = {
    "afDevKey": constant.AppsFlyerConstant.appsFlyerDevKey,
    "afAppId": constant.AppsFlyerConstant.getAppID(),
    "isDebug": kDebugMode,
    "timeToWaitForATTUserAuthorization": 5.0
  };

  static Future<void> initAppsFlyer() async {
    _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    await _appsflyerSdk?.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  static Future<void> logAppsFlyerEvent(
    String eventName,
    dynamic eventValue,
  ) async {
    await _appsflyerSdk!.logEvent(
      eventName,
      eventValue,
    );
  }
}
