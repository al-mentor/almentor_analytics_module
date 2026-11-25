library almentor_analytics_module;

import 'package:almentor_analytics_module/analytics_sdks/braze/braze_sdk.dart';
import 'package:almentor_analytics_module/analytics_sdks/meta/meta_event.dart';
import 'package:almentor_analytics_module/analytics_sdks/meta/meta_sdk.dart';
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
      MetaSdk.initMeta(prod);
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
          allowMixpanelEvent, allowBrazeEvent);
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

  /// Mixpanel only: links the anonymous ID to [userId] as soon as an account
  /// exists, before its user data is known (guest checkout). Errors go to
  /// [onError], as for the other calls; so do a blank [userId] and a call
  /// before Mixpanel is initialised, which would otherwise be lost silently.
  Future<void> identifyMixpanelUser(String userId) async {
    try {
      if (userId.trim().isEmpty) {
        throw ArgumentError.value(userId, 'userId', 'must not be blank');
      }
      if (MixPanelSdk.mixPanelSdk == null) {
        throw StateError('Mixpanel is not initialised');
      }
      await MixPanelSdk.identifyUser(userId);
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
  }

  Future<void> logUser(
    UserData userData, {
    bool allowFirebaseEvents = true,
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
      // Always called: Meta needs the user type to drop B2B events.
      await MetaSdk.logUser(userData);
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
      allowMixpanelEvent: allowMixpanelEvent,
      allowBrazeEvent: allowBrazeEvent,
    );
  }

  /// Sends [event] to Meta Ads Manager. See [MetaSdk] for when it is
  /// dropped. A [MetaEvent.purchase] needs [value] and [currency].
  Future<void> submitMetaEvent(
    MetaEvent event, {
    String? contentId,
    String? contentType,
    double? value,
    String? currency,
    String? registrationMethod,
    Map<String, Object>? parameters,
  }) async {
    try {
      await MetaSdk.log(
        event,
        contentId: contentId,
        contentType: contentType,
        value: value,
        currency: currency,
        registrationMethod: registrationMethod,
        parameters: parameters,
      );
    } catch (error, stackTrace) {
      AlmentorAnalyticsModule.onError!(error, stackTrace);
    }
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
            isMixPanelAllowed, isBrazeAllowed),
      );
    }
  }

  bool isEventValueValidMap(dynamic eventValue) {
    return eventValue != null && eventValue is Map;
  }

  void reset() {
    MixPanelSdk.rest();
    BrazeSdk.reset();
    MetaSdk.reset().catchError(AlmentorAnalyticsModule.onError!);
    FirebaseAnalytics.instance.resetAnalyticsData();
  }
}
