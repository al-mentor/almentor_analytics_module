library almentor_analytics_module;

import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/braze/braze_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/mixpanel/mixpanel_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_module.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlmentorAnalyticsModule {
  AlmentorAnalyticsModule._();

  static AlmentorAnalyticsModule? _instance;

  static AlmentorAnalyticsModule get instance {
    _instance ??= AlmentorAnalyticsModule._();
    return _instance!;
  }

  final List<EventModule> submittedEvents = [];

  Future<void> init(bool prod) async {
    try {
      await AppsFlyerSDK.initAppsFlyer(prod);
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
    try {
      await MixPanelSdk.initMixpanelSdk(prod);
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
    try {
      BrazeSdk.initBraze();
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
  }

  List<NavigatorObserver> getNavigatorObservers() {
    return <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ];
  }

  Future<void> submitEvent({
    required EventName eventName,
    dynamic eventValue,
    bool allowFirebaseEvents = true,
    bool allowAppsFlyerEvent = false,
    bool allowMixpanelEvent = false,
    bool allowBrazeEvent = false,
  }) async {
    if (allowFirebaseEvents) {
      try {
        submitFirebaseAnalyticsEvent(
          eventName: eventName,
          eventValue: isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (ex) {
        if (kDebugMode) {
          print(ex);
        }
      }
    }
    if (allowAppsFlyerEvent && AppsFlyerSDK.appsflyerSdk != null) {
      try {
        AppsFlyerSDK.logAppsFlyerEvent(
          eventName,
          isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (ex) {
        if (kDebugMode) {
          print(ex);
        }
      }
    }
    if (allowMixpanelEvent && MixPanelSdk.mixPanelSdk != null) {
      try {
        MixPanelSdk.logMixpanelEvent(
          eventName,
          isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (ex) {
        if (kDebugMode) {
          print(ex);
        }
      }
    }
    if (allowBrazeEvent && BrazeSdk.braze != null) {
      try {
        BrazeSdk.logBrazeEvent(
          eventName,
          isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (ex) {
        if (kDebugMode) {
          print(ex);
        }
      }
    }

    try {
      updateEventsList(
        eventName,
        eventValue,
        allowFirebaseEvents,
        allowAppsFlyerEvent,
        allowMixpanelEvent,
      );
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
  }

  Future<void> _logUserFirebase(UserData userData) async {
    await FirebaseAnalytics.instance.setUserId(id: userData.userId);
    if (userData.phoneNumber != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'phone_Number',
        value: userData.phoneNumber,
      );
    }
    if (userData.gender != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'gender',
        value: userData.gender,
      );
    }
    if (userData.language != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'language',
        value: userData.language,
      );
    }
    if (userData.isSubscribed != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'is_subscribed',
        value: userData.isSubscribed! ? 'Yes' : 'No',
      );
    }
  }

  Future<void> logUser(
    UserData userData, {
    bool allowFirebaseEvents = true,
    bool allowAppsFlyerEvent = true,
    bool allowMixpanelEvent = true,
    bool allowBrazeEvent = true,
  }) async {
    try {
      if (allowFirebaseEvents) {
        await _logUserFirebase(userData);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      if (allowAppsFlyerEvent) {
        AppsFlyerSDK.logUser(userData);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      if (allowBrazeEvent) {
        BrazeSdk.logUser(userData);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      if (allowMixpanelEvent) {
        MixPanelSdk.logUser(userData);
      }
    } catch (ex) {
      if (kDebugMode) {
        print(ex);
      }
    }
  }

  Future<void> submitFirebaseAnalyticsEvent({
    required EventName eventName,
    dynamic eventValue,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: eventName.convertToSnakeCase,
      parameters: eventValue,
    );
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
