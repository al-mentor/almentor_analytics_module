import 'package:almentor_analytics_module/analytics_sdks/meta/meta_event.dart';
import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

/// Sends app events to Meta (Facebook) Ads Manager.
///
/// Nothing is sent outside prod, and events of `Business` (B2B) users are
/// dropped once [logUser] has identified them. The SDK itself reads the iOS
/// tracking permission and sends limited data when tracking isn't allowed.
class MetaSdk {
  const MetaSdk._();

  static const businessUserType = 'Business';
  static const consumerUserType = 'Consumer';

  static FacebookAppEvents? _appEvents;
  static String? _userType;

  static void initMeta(bool prod) {
    if (prod) {
      _appEvents = FacebookAppEvents();
    }
  }

  static Future<void> logUser(UserData userData) async {
    _userType = userData.userType;
    final appEvents = _appEvents;
    final userId = userData.userId;
    if (appEvents == null ||
        userData.userType != consumerUserType ||
        userId == null ||
        userId.isEmpty) {
      return;
    }
    await appEvents.setUserID(userId);
    await appEvents.setUserData(
      email: userData.email,
      phone: userData.phoneNumber,
    );
  }

  static Future<void> reset() async {
    _userType = null;
    final appEvents = _appEvents;
    if (appEvents == null) return;
    await appEvents.clearUserID();
    await appEvents.clearUserData();
  }

  static Future<void> log(
    MetaEvent event, {
    String? contentId,
    String? contentType,
    double? value,
    String? currency,
    String? registrationMethod,
    Map<String, Object>? parameters,
  }) async {
    final appEvents = _appEvents;
    if (appEvents == null || _userType == businessUserType) return;

    final eventParameters = <String, Object>{
      ...?parameters,
      if (contentId != null) FacebookAppEvents.paramNameContentId: contentId,
      if (contentType != null)
        FacebookAppEvents.paramNameContentType: contentType,
      if (registrationMethod != null)
        FacebookAppEvents.paramNameRegistrationMethod: registrationMethod,
    };

    if (event == MetaEvent.purchase) {
      if (value == null || currency == null) {
        throw ArgumentError('A Meta purchase needs a value and a currency');
      }
      await appEvents.logPurchase(
        amount: value,
        currency: currency,
        parameters: eventParameters,
      );
      return;
    }
    await appEvents.logEvent(
      name: event.fbName,
      parameters: {
        ...eventParameters,
        if (currency != null) FacebookAppEvents.paramNameCurrency: currency,
      },
      valueToSum: value,
    );
  }

  @visibleForTesting
  static void resetForTesting() {
    _appEvents = null;
    _userType = null;
  }
}
