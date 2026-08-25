import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'apps_flyer_constant.dart';

class AppsFlyerSDK {
  const AppsFlyerSDK._();

  static AppsflyerSdk? _appsflyerSdk;

  static AppsflyerSdk? get appsflyerSdk => _appsflyerSdk;

  static final AppsFlyerOptions appsFlyerOptionsProd = AppsFlyerOptions(
    afDevKey: AppsFlyerConstant.appsFlyerDevKey,
    appId: AppsFlyerConstant.getAppID(),
    showDebug: false,
    timeToWaitForATTUserAuthorization: 5.0,
    // appInviteOneLink: "your_appInviteOneLink_here",
    disableAdvertisingIdentifier: false,
    disableCollectASA: false,
    manualStart: false,
  );

  static final AppsFlyerOptions appsFlyerOptionsStage = AppsFlyerOptions(
    afDevKey: AppsFlyerConstant.appsFlyerDevKey,
    appId: AppsFlyerConstant.getAppStageID(),
    showDebug: false,
    timeToWaitForATTUserAuthorization: 5.0,
    // appInviteOneLink: "your_appInviteOneLink_here",
    disableAdvertisingIdentifier: false,
    disableCollectASA: true,
    manualStart: false,
  );

  static void logUser(UserData userData) {
    if (userData.userId != null) {
      _appsflyerSdk!.setCustomerUserId(userData.userId!);
    }
    if (userData.email != null) {
      _appsflyerSdk!.setUserEmails([userData.email!]);
    }
    _appsflyerSdk!.setAdditionalData(userData.toJson());
  }

  static Future<void> initAppsFlyer(bool prod) async {
    if (prod) {
      _appsflyerSdk = AppsflyerSdk(appsFlyerOptionsProd);
    } else {
      _appsflyerSdk = AppsflyerSdk(appsFlyerOptionsStage);
    }
    _appsflyerSdk?.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
    );
  }

  /// Clears the identity we attached to the AppsFlyer session (called on
  /// logout).
  ///
  /// Deliberately does not call `setUserEmails([])`: on Android the SDK builds
  /// its emails JSONObject with a key that is only assigned while iterating the
  /// emails array, so an empty array leaves that key null and
  /// `new JSONObject(map)` throws `NullPointerException: key == null`
  /// (Sentry FLUTTER-ZF-1CD). AppsFlyer offers no supported way to clear the
  /// stored emails, and the empty call never cleared them anyway — it only
  /// threw. Clearing the customer user id is what actually de-identifies the
  /// session.
  static void rest() {
    _appsflyerSdk!.setCustomerUserId("");
    _appsflyerSdk!.setAdditionalData({});
  }

  static Future<void> logAppsFlyerEvent(
    EventName eventName,
    dynamic eventValue,
  ) async {
    await _appsflyerSdk!.logEvent(
      eventName.convertToSnakeCase,
      eventValue,
    );
  }
}
