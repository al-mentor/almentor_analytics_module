library almentor_analytics_module;

import 'package:almentor_analytics_module/analytics_sdks/apps_flyer/apps_flyer_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/braze/braze_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/mixpanel/mixpanel_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_module.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AlmentorAnalyticsModule {
  AlmentorAnalyticsModule._();

  static AlmentorAnalyticsModule? _instance;
  UserData? _currentUserData;

  static AlmentorAnalyticsModule get instance {
    _instance ??= AlmentorAnalyticsModule._();
    return _instance!;
  }

  final List<EventModule> submittedEvents = [];
  static Function(Object error, StackTrace stackTrace)? onError =
      (error, stackTrace) {
    if (kDebugMode) {
      print(error.toString());
    }
  };

  Future<void> requestTrackingAuthorization(bool prod) async {
    await Future.delayed(const Duration(seconds: 2));
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status != TrackingStatus.authorized) {
      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> init(
      bool prod, Function(Object error, StackTrace stackTrace)? onError) async {
    AlmentorAnalyticsModule.onError = onError;

    intSDK(prod);
  }

  Future<void> intSDK(bool prod) async {
    try {
      await AppsFlyerSDK.initAppsFlyer(prod);
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
    try {
      await MixPanelSdk.initMixpanelSdk(prod);
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
    try {
      BrazeSdk.initBraze();
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
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
    eventValue?.removeWhere((key, value) => value == null);

    if (allowFirebaseEvents) {
      try {
        submitFirebaseAnalyticsEvent(
          eventName: eventName,
          eventValue: isEventValueValidMap(eventValue)
              ? Map<String, Object>.from(eventValue)
              : null,
        );
      } catch (error, stackTrace) {
        AlmentorAnalyticsModule.onError!(error, stackTrace);
      }
    }
    if (allowAppsFlyerEvent && AppsFlyerSDK.appsflyerSdk != null) {
      try {
        AppsFlyerSDK.logAppsFlyerEvent(
          eventName,
          isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (error, stackTrace) {
        AlmentorAnalyticsModule.onError!(error, stackTrace);
      }
    }
    if (allowMixpanelEvent && MixPanelSdk.mixPanelSdk != null) {
      try {
        MixPanelSdk.logMixpanelEvent(
          eventName,
          isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (error, stackTrace) {
        AlmentorAnalyticsModule.onError!(error, stackTrace);
      }
    }
    if (allowBrazeEvent &&
        BrazeSdk.braze != null &&
        _currentUserData != null &&
        _currentUserData?.userType == "Consumer") {
      try {
        BrazeSdk.logBrazeEvent(
          eventName,
          isEventValueValidMap(eventValue) ? eventValue : null,
        );
      } catch (error, stackTrace) {
        AlmentorAnalyticsModule.onError!(error, stackTrace);
      }
    }

    try {
      updateEventsList(eventName, eventValue, allowFirebaseEvents,
          allowAppsFlyerEvent, allowMixpanelEvent, allowBrazeEvent);
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> _logUserFirebase(UserData userData) async {
    if(userData.userId == null || userData.userId!.isEmpty){
      return;
    }

    await FirebaseAnalytics.instance.setUserId(id: userData.userId);
    FirebaseCrashlytics.instance.setUserIdentifier(userData.userId ?? "");

    if (userData.phoneNumber != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'phone_Number',
        value: userData.phoneNumber,
      );
      FirebaseCrashlytics.instance
          .setCustomKey('phone_Number', userData.phoneNumber ?? "");
    }
    if (userData.gender != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'gender',
        value: userData.gender,
      );

      FirebaseCrashlytics.instance
          .setCustomKey('gender', userData.gender ?? "");
    }

    if (userData.email != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'email',
        value: userData.email,
      );

      FirebaseCrashlytics.instance.setCustomKey('email', userData.email ?? "");
    }
    if (userData.language != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'language',
        value: userData.language,
      );

      FirebaseCrashlytics.instance
          .setCustomKey('language', userData.language ?? "");
    }
    if (userData.isSubscribed != null) {
      await FirebaseAnalytics.instance.setUserProperty(
        name: 'is_subscribed',
        value: userData.isSubscribed! ? 'Yes' : 'No',
      );

      FirebaseCrashlytics.instance
          .setCustomKey('is_subscribed', userData.isSubscribed! ? 'Yes' : 'No');
    }
  }
  void incrementByMixpanel({required String prop,required double value}){
    MixPanelSdk.incrementByMixpanel(prop: prop, value: value);
  }
  Future<void> logUser(
    UserData userData, {
    bool allowFirebaseEvents = true,
    bool allowAppsFlyerEvent = true,
    bool allowMixpanelEvent = true,
    bool allowBrazeEvent = true,
  }) async {
    _currentUserData = userData;

    try {
      if (allowFirebaseEvents) {
        await _logUserFirebase(userData);
      }
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
    try {
      if (allowAppsFlyerEvent) {
        AppsFlyerSDK.logUser(userData);
      }
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
    try {
      if (allowBrazeEvent && userData.userType == "Consumer") {
        BrazeSdk.logUser(userData);
      }
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
    try {
      if (allowMixpanelEvent) {
        await MixPanelSdk.logUser(userData);
      }
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }

    submitEvent(
      eventName: EventName.userDataEvent,
      eventValue: userData.toJson(),
      allowFirebaseEvents: allowFirebaseEvents,
      allowAppsFlyerEvent: allowAppsFlyerEvent,
      allowMixpanelEvent: allowMixpanelEvent,
      allowBrazeEvent: allowBrazeEvent,
    );
  }

  Future<void> submitFirebaseAnalyticsEvent({
    required EventName eventName,
    dynamic eventValue,
  }) async {
    if (eventValue is Map) {
      eventValue.forEach((key, value) {
        if (value is List) {
          eventValue[key] = value.toString();
        }
      });
    }

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
    bool isBrazeAllowed,
  ) {
    final isExists =
        submittedEvents.any((event) => event.eventName == eventName);
    if (isExists) {
      submittedEvents[submittedEvents
              .indexWhere((event) => event.eventName == eventName)]
          .count++;
    } else {
      submittedEvents.add(
        EventModule(eventName, eventValue, 1, isFirebaseAllowed,
            isAppsFlyerAllowed, isMixPanelAllowed, isBrazeAllowed),
      );
    }
  }

  bool isEventValueValidMap(dynamic eventValue) {
    return eventValue != null && eventValue is Map;
  }

  void reset() {
    MixPanelSdk.rest();
    BrazeSdk.reset();
    AppsFlyerSDK.rest();
    FirebaseAnalytics.instance.resetAnalyticsData();
  }
}
