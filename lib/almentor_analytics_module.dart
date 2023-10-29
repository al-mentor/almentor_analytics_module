library almentor_analytics_module;

import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class AlmentorAnalyticsModule {
  const AlmentorAnalyticsModule._();

  static AlmentorAnalyticsModule get instance =>
      const AlmentorAnalyticsModule._();

  init() {
    //TODO apply initialization for analytics SDKs that need initializing
  }

  Future<void> submitEvent(
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
