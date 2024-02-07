import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_constant.dart'
    as constant;
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';

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

  static void logUser(UserData userData) {
    _appsflyerSdk!.setCustomerUserId(userData.userId);
    if (userData.email != null) {
      _appsflyerSdk!.setUserEmails([userData.email!]);
    }
    _appsflyerSdk!.setAdditionalData(userData.toJson());
  }

  static Future<void> initAppsFlyer() async {
    _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
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
