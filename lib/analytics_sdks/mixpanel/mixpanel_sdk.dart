import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelSdk {
  const MixPanelSdk._();

  static Mixpanel? _mixPanelSdk;

  static Mixpanel? get mixPanelSdk => _mixPanelSdk;

  static Future<void> initMixpanelSdk(bool prod) async {
    if (prod) {
      _mixPanelSdk = await Mixpanel.init('df04c80eff821c07529540963fca1d83',
          trackAutomaticEvents: true);

    }else {
      _mixPanelSdk = await Mixpanel.init('a00d0aa23e868278584142eddfbdccfe',
        trackAutomaticEvents: true,
      );
    }
    _mixPanelSdk!.setServerURL("https://api-eu.mixpanel.com");
  }

  static logUser(UserData userData) async {
    _mixPanelSdk?.registerSuperProperties(userData.toJson());
    final userId = userData.userId;
    if (userId != null) await identifyUser(userId);
  }

  /// Links this device's anonymous Mixpanel ID to [userId] without sending
  /// user properties, so events before and after an account is created count
  /// as one person (`identify` merges them under ID merge, as at log-in).
  static Future<void> identifyUser(String userId) async {
    final distinctId = await _mixPanelSdk?.getDistinctId();
    if (distinctId != userId) await _mixPanelSdk?.identify(userId);
  }

  static void incrementByMixpanel(
      {required String prop, required double value}) {
    // increment "age" by 2
    _mixPanelSdk?.getPeople().increment(prop, value);
  }

  static void logMixpanelEvent(
    EventName eventName,
    dynamic eventValue,
  ) {
    _mixPanelSdk?.track(eventName.convertToSnakeCase, properties: eventValue);
  }

  static void rest() {
    _mixPanelSdk?.reset();
  }
}
