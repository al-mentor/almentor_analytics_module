import 'package:almentor_analytics_module/analytics_sdks/user_data.dart';
import 'package:almentor_analytics_module/event_name_mapper.dart';
import 'package:almentor_analytics_module/events_name.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixPanelSdk {
  const MixPanelSdk._();

  static Mixpanel? _mixPanelSdk;

  static Mixpanel? get mixPanelSdk => _mixPanelSdk;

  static Future<void> initMixpanelSdk(bool prod) async {


    if(prod){
      _mixPanelSdk = await Mixpanel.init('df04c80eff821c07529540963fca1d83',
          trackAutomaticEvents: true);

    }else {
      _mixPanelSdk = await Mixpanel.init('e5c9d92fd6fdf110e85a4fecf1fb0298',
        trackAutomaticEvents: true,
      );
    }
  }

  static   logUser(UserData userData) async {
    final userDistinctId = await _mixPanelSdk?.getDistinctId();
    _mixPanelSdk?.registerSuperProperties(userData.toJson());
    if (userDistinctId != userData.userId && userData.userId != null) {
      _mixPanelSdk?.identify(userData.userId!);
    }
  }

  static void incrementByMixpanel({required String prop,required double value}){
    // increment "age" by 2
    _mixPanelSdk?.getPeople().increment(prop,value);
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
