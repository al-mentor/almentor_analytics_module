library almentor_analytics_module;

import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/mixpanel/mixpanel_sdk.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class AlmentorAnalyticsModule {
  const AlmentorAnalyticsModule._();

  static AlmentorAnalyticsModule get instance =>
      const AlmentorAnalyticsModule._();

  Future<void> init() async {
    await AppsFlyerSDK.initAppsFlyer();
    await MixPanelSdk.initMixpanelSdk();
  }

  Future<void> submitEvent({
    required EventName eventName,
    dynamic eventValue,
    bool allowFirebaseEvents = true,
    bool allowAppsFlyerEvent = true,
    bool allowMixpanelEvent = true,
  }) async {
    if (allowFirebaseEvents) {
      await submitFirebaseAnalyticsEvent(
          eventName: eventName, eventValue: eventValue);
    }
    if (allowAppsFlyerEvent && AppsFlyerSDK.appsflyerSdk != null) {
      await AppsFlyerSDK.logAppsFlyerEvent(eventName.value, eventValue);
    }
    if (allowMixpanelEvent && MixPanelSdk.mixPanelSdk != null) {
      MixPanelSdk.logMixpanelEvent(eventName.value, eventValue);
    }
  }

  Future<void> submitFirebaseAnalyticsEvent(
      {required EventName eventName, dynamic eventValue}) async {
    try {
      await FirebaseAnalytics.instance
          .logEvent(name: eventName.value, parameters: eventValue);
      debugPrint('${eventName.value} Event logged Successfully');
    } catch (e) {
      debugPrint('${eventName.value} Event logged failed with Exception $e');
    }
  }
}
