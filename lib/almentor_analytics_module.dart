library almentor_analytics_module;

import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_sdk.dart';
import 'package:almentor_analytics_module/event_module.dart';
import 'package:almentor_analytics_module/analytics_sdks/mixpanel/mixpanel_sdk.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class AlmentorAnalyticsModule {
  AlmentorAnalyticsModule._();

  static AlmentorAnalyticsModule? _instance;

  static AlmentorAnalyticsModule get instance {
    _instance ??= AlmentorAnalyticsModule._();
    return _instance!;
  }

  final List<EventModule> submittedEvents = [];

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
      await AppsFlyerSDK.logAppsFlyerEvent(eventName, eventValue);
    }
    if (allowMixpanelEvent && MixPanelSdk.mixPanelSdk != null) {
      MixPanelSdk.logMixpanelEvent(eventName, eventValue);
    }

    updateEventsList(
      eventName,
      eventValue,
      allowFirebaseEvents,
      allowAppsFlyerEvent,
      allowMixpanelEvent,
    );
  }

  Future<void> submitFirebaseAnalyticsEvent({
    required EventName eventName,
    dynamic eventValue,
  }) async {
    if (eventValue is Map<String, dynamic>) {
      await FirebaseAnalytics.instance.logEvent(
        name: eventName.convertToSnakeCase,
        parameters: eventValue,
      );
    } else {
      print("Invalid eventValue type. Expected Map<String, dynamic>.");
      // Handle the invalid type case appropriately
    }
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
}
