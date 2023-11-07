import 'package:almentor_analytics_module/events_name.dart';

class EventModule {
  EventName eventName;
  dynamic eventValue;
  int count;
  bool isFirebaseAllowed;
  bool isAppsFlyerAllowed;
  bool isMixPanelAllowed;

  EventModule(this.eventName, this.eventValue, this.count,
      this.isFirebaseAllowed, this.isAppsFlyerAllowed, this.isMixPanelAllowed);
}
