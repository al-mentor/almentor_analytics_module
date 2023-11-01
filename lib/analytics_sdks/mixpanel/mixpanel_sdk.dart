import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelSdk {
  const MixPanelSdk._();

  static Mixpanel? _mixPanelSdk;

  static Mixpanel? get mixPanelSdk => _mixPanelSdk;

  static Future<void> initMixpanelSdk() async {
    _mixPanelSdk = await Mixpanel.init('df04c80eff821c07529540963fca1d83',
        trackAutomaticEvents: true);
  }

  static void logMixpanelEvent(
    String eventName,
    dynamic eventValue,
  ) {
    _mixPanelSdk!.track(eventName, properties: eventValue);
  }
}
