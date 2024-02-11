import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_constant.dart'
    as constant;

class AppsFlyerSDK {
  const AppsFlyerSDK._();

  static AppsflyerSdk? _appsflyerSdk;

  static AppsflyerSdk? get appsflyerSdk => _appsflyerSdk;

  static final appsFlyerOptionsProd = {
    "afDevKey": constant.AppsFlyerConstant.appsFlyerDevKey,
    "afAppId": constant.AppsFlyerConstant.getAppID(),
    "isDebug": kDebugMode,
    "timeToWaitForATTUserAuthorization": 5.0
  };

  static final appsFlyerOptionsStage = {
    "afDevKey": constant.AppsFlyerConstant.appsFlyerDevKey,
    "afAppId": constant.AppsFlyerConstant.getAppID(),
    "isDebug": kDebugMode,
    "timeToWaitForATTUserAuthorization": 5.0
  };


  static Future<void> initAppsFlyer(bool prod) async {
    if(prod){
      _appsflyerSdk = AppsflyerSdk(appsFlyerOptionsProd);

    }else{
      _appsflyerSdk = AppsflyerSdk(appsFlyerOptionsStage);

    }
    await _appsflyerSdk?.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  static Future<void> logAppsFlyerEvent(
    EventName eventName,
    dynamic eventValue,
  ) async {
    await _appsflyerSdk!.logEvent(
      eventName.convertToTitleCase,
      eventValue,
    );
  }
}
