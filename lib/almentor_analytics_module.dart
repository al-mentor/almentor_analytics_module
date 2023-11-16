library almentor_analytics_module;

import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/mixpanel/mixpanel_sdk.dart';
import 'package:almentor_analytics_module/event_module.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AlmentorAnalyticsModule {
  AlmentorAnalyticsModule._();

  static AlmentorAnalyticsModule? _instance;

  static AlmentorAnalyticsModule get instance {
    _instance ??= AlmentorAnalyticsModule._();
    return _instance!;
  }

  final List<EventModule> submittedEvents = [];

  Future<void> init() async {
    try{
    await AppsFlyerSDK.initAppsFlyer();
    await MixPanelSdk.initMixpanelSdk();
    }catch(ex){}
  }

  Future<void> submitEvent({
    required EventName eventName,
    dynamic eventValue,
    bool allowFirebaseEvents = true,
    bool allowAppsFlyerEvent = true,
    bool allowMixpanelEvent = true,
  }) async {
    try{
    if (allowFirebaseEvents) {
      submitFirebaseAnalyticsEvent(
          eventName: eventName,
          eventValue: isEventValueValidMap(eventValue) ? eventValue : null);
          }catch(ex){}
    }
    if (allowAppsFlyerEvent && AppsFlyerSDK.appsflyerSdk != null) {
      try{
      AppsFlyerSDK.logAppsFlyerEvent(
          eventName, isEventValueValidMap(eventValue) ? eventValue : null);
      }catch(ex){}
    }
    if (allowMixpanelEvent && MixPanelSdk.mixPanelSdk != null) {
      try{
      MixPanelSdk.logMixpanelEvent(
          eventName, isEventValueValidMap(eventValue) ? eventValue : null);
      }catch(ex){}
    }

try{
    updateEventsList(
      eventName,
      eventValue,
      allowFirebaseEvents,
      allowAppsFlyerEvent,
      allowMixpanelEvent,
    );
}catch(ex){}
  }

  Future<void> submitFirebaseAnalyticsEvent(
      {required EventName eventName, dynamic eventValue}) async {
    await FirebaseAnalytics.instance
        .logEvent(name: eventName.convertToSnakeCase, parameters: eventValue);
  }

  void updateEventsList(
    EventName eventName,
    dynamic eventValue,
    bool isFirebaseAllowed,
    bool isAppsFlyerAllowed,
    bool isMixPanelAllowed,
  ) {
    final isExists =
        submittedEvents.any((event) => event.eventName == eventName);
    if (isExists) {
      submittedEvents[submittedEvents
              .indexWhere((event) => event.eventName == eventName)]
          .count++;
    } else {
      submittedEvents.add(
        EventModule(
          eventName,
          eventValue,
          1,
          isFirebaseAllowed,
          isAppsFlyerAllowed,
          isMixPanelAllowed,
        ),
      );
    }
  }

  bool isEventValueValidMap(dynamic eventValue) {
    return eventValue != null && eventValue is Map;
  }
}
