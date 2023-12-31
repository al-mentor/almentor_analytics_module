import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelSdk {
  const MixPanelSdk._();

  static Mixpanel? _mixPanelSdk;

  static Mixpanel? get mixPanelSdk => _mixPanelSdk;

  static Future<void> initMixpanelSdk() async {
    _mixPanelSdk = await Mixpanel.init('e5c9d92fd6fdf110e85a4fecf1fb0298',
        trackAutomaticEvents: true);
  }

  static void logMixpanelEvent(
    EventName eventName,
    dynamic eventValue,
  ) {
    _mixPanelSdk!.track(eventName.convertToTitleCase, properties: eventValue);
  }
}
